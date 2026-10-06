-- CineFlow 统计模块精简迁移
-- 目标：9 张核心业务表 + 4 张统计聚合表，共 13 张物理表。
-- 适用：MySQL 8.x，数据库 cineflow_db。
--
-- 重要：MySQL DDL 会隐式提交，ROLLBACK 不能恢复 DROP TABLE。
-- 执行前先备份：
-- mysqldump -uroot -p --single-transaction --routines --triggers cineflow_db > cineflow_db_before_stat_cleanup.sql

USE cineflow_db;

-- 1. 执行前检查。请确认下列对象确实属于准备删除的旧统计模块。
SELECT table_name, table_type
FROM information_schema.tables
WHERE table_schema = DATABASE()
  AND table_name IN (
      'stat_genre_count',
      'stat_language',
      'stat_movie_year',
      'stat_region_count',
      'stat_score_section',
      'stat_year_avg_mins',
      'stat_region_top50',
      'stat_high_score_avg',
      'stat_mins_total'
  )
ORDER BY table_name;

-- 2. 先删除可能依赖旧表的视图。
DROP VIEW IF EXISTS stat_region_top50;
DROP VIEW IF EXISTS stat_high_score_avg;
DROP VIEW IF EXISTS stat_mins_total;

-- 3. 如果旧版本把这三个对象误建成了物理表，也一并清理。
DROP TABLE IF EXISTS stat_region_top50;
DROP TABLE IF EXISTS stat_high_score_avg;
DROP TABLE IF EXISTS stat_mins_total;

-- 4. 删除六张简单、低价值或重复的聚合表。
DROP TABLE IF EXISTS stat_genre_count;
DROP TABLE IF EXISTS stat_language;
DROP TABLE IF EXISTS stat_movie_year;
DROP TABLE IF EXISTS stat_region_count;
DROP TABLE IF EXISTS stat_score_section;
DROP TABLE IF EXISTS stat_year_avg_mins;

-- 5. 验证必须保留的四张复杂聚合表。
SELECT table_name, table_rows
FROM information_schema.tables
WHERE table_schema = DATABASE()
  AND table_type = 'BASE TABLE'
  AND table_name IN (
      'stat_actor_top50',
      'stat_region_year_avg_score',
      'stat_year_region_count',
      'stat_year_top20_movie'
  )
ORDER BY table_name;

-- 6. 验证物理表总数。完整 CineFlow 库的预期结果是 13。
SELECT COUNT(*) AS physical_table_count
FROM information_schema.tables
WHERE table_schema = DATABASE()
  AND table_type = 'BASE TABLE';

-- 7. 验证旧对象全部消失。预期返回 0 行。
SELECT table_name, table_type
FROM information_schema.tables
WHERE table_schema = DATABASE()
  AND table_name IN (
      'stat_genre_count',
      'stat_language',
      'stat_movie_year',
      'stat_region_count',
      'stat_score_section',
      'stat_year_avg_mins',
      'stat_region_top50',
      'stat_high_score_avg',
      'stat_mins_total'
  );
