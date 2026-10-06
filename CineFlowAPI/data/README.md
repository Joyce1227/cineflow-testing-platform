# 外部电影数据导入

`douban_top200_movies.sql` 是从豆瓣 Top 250 公开榜单前200条生成的 MySQL 8 导入文件。它只使用榜单页直接展示的字段；语言、完整上映日期、片长和剧情简介没有可靠来源，因此保持 `NULL`。

导入前请确认目标是开发或测试数据库并完成备份。SQL 不包含 `USE`，必须在命令中明确选择数据库：

```powershell
mysql --default-character-set=utf8mb4 -u root -p cineflow_db -e "source D:/MovieTicketingAndRecommendationSystem/CineFlowAPI/data/douban_top200_movies.sql"
```

文件会先按“片名+年份”为已有演示电影补充 `douban_id`，再按 `douban_id` 唯一键执行更新或插入，所以可重复执行。它不会创建场次和座位；导入后的电影用于列表、筛选、统计、热门推荐及 AI 测试背景，只有另行配置场次的电影才能购票。

重新获取榜单快照：

```powershell
cd D:\MovieTicketingAndRecommendationSystem\CineFlowAPI
.\.venv\Scripts\python.exe scripts\scrape_douban_top.py --limit 200 --delay 5 --output data\douban_top200_movies.sql
```

脚本会校验每页条数、排名连续性和豆瓣 ID 唯一性；页面结构变化时会停止生成，而不是输出残缺数据。
