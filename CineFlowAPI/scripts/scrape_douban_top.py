"""低频读取豆瓣 Top 250 的前 N 条，并生成 CineFlow MySQL 导入 SQL。

榜单页只包含公开展示的基础元数据。本脚本不会访问用户数据，也不会把榜单短评
冒充剧情简介；语言、日期、片长和 storyline 保持 NULL。
"""

from __future__ import annotations

import argparse
import html
import re
import time
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path
from urllib.request import Request, urlopen


TOP_URL = "https://movie.douban.com/top250?filter=&start={start}"
USER_AGENT = "CineFlowDataImporter/1.0 (educational project)"


@dataclass(frozen=True)
class MovieRow:
    rank: int
    douban_id: str
    name: str
    alias: str | None
    actors: str | None
    directors: str | None
    cover: str | None
    genres: str
    regions: str
    release_year: int | None
    score: float
    rating_count: int


def clean_html(fragment: str) -> str:
    """把小段榜单 HTML 转成规范单行文本。"""
    value = re.sub(r"<br\s*/?>", "\n", fragment, flags=re.IGNORECASE)
    value = re.sub(r"<[^>]+>", "", value)
    value = html.unescape(value).replace("\xa0", " ")
    return re.sub(r"[ \t]+", " ", value).strip()


def first(pattern: str, text: str, default: str = "") -> str:
    match = re.search(pattern, text, flags=re.DOTALL | re.IGNORECASE)
    return html.unescape(match.group(1)).strip() if match else default


def parse_page(page: str) -> list[MovieRow]:
    """解析一个25条榜单分页；页面结构异常时立即失败，避免输出残缺 SQL。"""
    blocks = re.findall(r'<div class="item">(.*?)</li>', page, flags=re.DOTALL)
    rows: list[MovieRow] = []
    for block in blocks:
        rank_text = first(r"<em[^>]*>(\d+)</em>", block)
        douban_id = first(r"movie\.douban\.com/subject/(\d+)/", block)
        titles = [clean_html(value) for value in re.findall(
            r'<span class="(?:title|other)">(.*?)</span>', block, flags=re.DOTALL
        )]
        titles = [value.lstrip("/ ") for value in titles if value.lstrip("/ ")]
        info_html = first(r'<div class="bd">\s*<p[^>]*>(.*?)</p>', block)
        info_parts = clean_html(info_html).splitlines()
        people = info_parts[0].strip() if info_parts else ""
        metadata = info_parts[-1].strip() if len(info_parts) > 1 else ""

        director_text, _, actor_text = people.partition("主演:")
        directors = re.sub(r"^导演:\s*", "", director_text).strip() or None
        actors = actor_text.strip() or None
        metadata_parts = [part.strip() for part in metadata.split("/")]
        year_match = re.search(r"(?:18|19|20)\d{2}", metadata_parts[0] if metadata_parts else "")
        regions = "/".join((metadata_parts[1] if len(metadata_parts) > 1 else "").split())
        genres = "/".join((metadata_parts[2] if len(metadata_parts) > 2 else "").split())
        rating_text = first(r'<span class="rating_num"[^>]*>([\d.]+)</span>', block, "0")
        votes_text = first(r'<span>(\d+)人评价</span>', block, "0")

        if not rank_text or not douban_id or not titles:
            raise ValueError("豆瓣榜单页面结构发生变化，缺少排名、条目 ID 或片名")
        rows.append(MovieRow(
            rank=int(rank_text), douban_id=douban_id, name=titles[0],
            alias=" / ".join(titles[1:])[:255] or None,
            actors=actors, directors=directors,
            cover=first(r'<img[^>]+src="([^"]+)"', block) or None,
            genres=genres[:255], regions=regions[:255],
            release_year=int(year_match.group()) if year_match else None,
            score=float(rating_text), rating_count=int(votes_text),
        ))
    if len(rows) != 25:
        raise ValueError(f"榜单分页应包含25条，实际解析到 {len(rows)} 条")
    return rows


def fetch_page(start: int, timeout: float = 20) -> str:
    request = Request(TOP_URL.format(start=start), headers={"User-Agent": USER_AGENT})
    with urlopen(request, timeout=timeout) as response:
        return response.read().decode("utf-8")


def sql_value(value: object) -> str:
    if value is None:
        return "NULL"
    if isinstance(value, (int, float)):
        return str(value)
    # SQL 标准的单引号加倍可避免电影名中的撇号破坏语句。
    return "'" + str(value).replace("'", "''") + "'"


def render_sql(rows: list[MovieRow]) -> str:
    generated_at = datetime.now(timezone.utc).isoformat()
    lines = [
        "-- CineFlow 豆瓣 Top 200 电影导入文件",
        f"-- 抓取时间（UTC）：{generated_at}",
        "-- 来源：https://movie.douban.com/top250（仅取公开榜单前200条）",
        "-- 说明：榜单未提供的语言、上映日期、片长和完整剧情保持 NULL。",
        "-- 幂等策略：先按片名+年份关联已有演示数据，再按 douban_id 更新或插入。",
        "SET NAMES utf8mb4;",
        "START TRANSACTION;",
        "",
    ]
    columns = ("douban_id, name, alias, actors, directors, cover, genres, regions, "
               "languages, release_year, release_date, mins, storyline, score, "
               "rating_count, popularity, status, created_at, updated_at")
    updates = ("name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), "
               "directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), "
               "regions=VALUES(regions), release_year=VALUES(release_year), "
               "score=VALUES(score), rating_count=VALUES(rating_count), "
               "popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6)")

    for row in rows:
        year_condition = "IS NULL" if row.release_year is None else f"= {row.release_year}"
        lines.extend([
            f"-- Top {row.rank}: {row.name}",
            "UPDATE movie SET "
            f"douban_id={sql_value(row.douban_id)}, updated_at=UTC_TIMESTAMP(6) "
            f"WHERE douban_id IS NULL AND name={sql_value(row.name)} "
            f"AND release_year {year_condition} LIMIT 1;",
            f"INSERT INTO movie ({columns}) VALUES (",
            "    " + ", ".join([
                sql_value(row.douban_id), sql_value(row.name), sql_value(row.alias),
                sql_value(row.actors), sql_value(row.directors), sql_value(row.cover),
                sql_value(row.genres), sql_value(row.regions), "NULL",
                sql_value(row.release_year), "NULL", "NULL", "NULL",
                f"{row.score:.2f}", str(row.rating_count), str(row.rating_count),
                "'AVAILABLE'", "UTC_TIMESTAMP(6)", "UTC_TIMESTAMP(6)",
            ]) + ")",
            f"ON DUPLICATE KEY UPDATE {updates};",
            "",
        ])
    lines.extend(["COMMIT;", ""])
    return "\n".join(lines)


def main() -> None:
    parser = argparse.ArgumentParser(description="生成 CineFlow 豆瓣 Top 电影 MySQL 导入文件")
    parser.add_argument("--limit", type=int, default=200, choices=range(25, 251, 25))
    parser.add_argument("--delay", type=float, default=5.0, help="分页请求间隔秒数")
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()

    rows: list[MovieRow] = []
    for start in range(0, args.limit, 25):
        rows.extend(parse_page(fetch_page(start)))
        print(f"已读取 {len(rows)}/{args.limit}")
        if len(rows) < args.limit:
            time.sleep(max(args.delay, 1.0))

    rows = rows[:args.limit]
    if [row.rank for row in rows] != list(range(1, args.limit + 1)):
        raise ValueError("榜单排名不连续，拒绝生成 SQL")
    if len({row.douban_id for row in rows}) != args.limit:
        raise ValueError("存在重复豆瓣条目 ID，拒绝生成 SQL")

    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(render_sql(rows), encoding="utf-8")
    print(f"SQL 已生成：{args.output.resolve()}")


if __name__ == "__main__":
    main()
