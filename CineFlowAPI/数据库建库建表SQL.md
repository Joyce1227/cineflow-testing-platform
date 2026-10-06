# CineFlowAPI 数据库建库建表 SQL

## 1. 使用说明

本文档适用于 MySQL 8.0.16 及以上版本，包含：

- 1 个数据库：`cineflow_db`；
- 9 张核心业务表；
- 4 张复杂、常用的统计聚合表；
- 高分均值和片长汇总由接口直接查询 `movie` 表，不再建立统计表或视图；
- 外键、联合主键、唯一约束和高频查询索引。

统计表调整方案：

| 处理方式 | 对象 |
|---|---|
| 保留物理表 | `stat_actor_top50`、`stat_region_year_avg_score`、`stat_year_region_count`、`stat_year_top20_movie` |
| 实时查询 | 高分电影均值、电影片长汇总 |
| 删除 | 类型、语言、年份、地区、评分区间、年份平均片长等简单或重复聚合 |

精简后的数据库共有 **13 张物理表：9 张核心业务表 + 4 张统计聚合表**。

> 执行前请确认当前连接不是生产数据库。以下 SQL 只使用 `CREATE DATABASE/TABLE IF NOT EXISTS`，不会主动删除已有表。

## 2. 建库 SQL

```sql
CREATE DATABASE IF NOT EXISTS cineflow_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_0900_ai_ci;

USE cineflow_db;

SET NAMES utf8mb4;
SET time_zone = '+00:00';
```

## 3. 核心业务表

### 3.1 用户表

```sql
CREATE TABLE IF NOT EXISTS app_user (
    id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '用户主键',
    username        VARCHAR(32)      NOT NULL COMMENT '登录用户名',
    phone           VARCHAR(11)      NOT NULL COMMENT '手机号',
    email           VARCHAR(128)     NOT NULL COMMENT '邮箱',
    password_hash   VARCHAR(255)     NOT NULL COMMENT '密码哈希，禁止保存明文',
    role            VARCHAR(16)      NOT NULL DEFAULT 'USER' COMMENT 'USER/ADMIN',
    status          VARCHAR(16)      NOT NULL DEFAULT 'ACTIVE' COMMENT 'ACTIVE/DISABLED',
    created_at      DATETIME(6)      NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at      DATETIME(6)      NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
                                      ON UPDATE CURRENT_TIMESTAMP(6),
    PRIMARY KEY (id),
    UNIQUE KEY uk_user_username (username),
    UNIQUE KEY uk_user_phone (phone),
    UNIQUE KEY uk_user_email (email),
    KEY idx_user_role_status (role, status),
    CONSTRAINT chk_user_role CHECK (role IN ('USER', 'ADMIN')),
    CONSTRAINT chk_user_status CHECK (status IN ('ACTIVE', 'DISABLED'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
  COMMENT='系统用户表';
```

### 3.2 电影表

`douban_id` 对应原始 `movies.csv` 中的 `MOVIE_ID`，正式导入数据集时应使用该字段去重。

```sql
CREATE TABLE IF NOT EXISTS movie (
    id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '系统内部电影ID',
    douban_id       VARCHAR(32)      NULL COMMENT '豆瓣电影ID/原始数据集MOVIE_ID',
    name            VARCHAR(255)     NOT NULL COMMENT '电影名称',
    alias           VARCHAR(255)     NULL COMMENT '电影别名',
    actors          TEXT             NULL COMMENT '演员展示文本',
    directors       TEXT             NULL COMMENT '导演展示文本',
    cover           VARCHAR(500)     NULL COMMENT '封面地址',
    genres          VARCHAR(255)     NOT NULL DEFAULT '' COMMENT '类型，使用/分隔',
    regions         VARCHAR(255)     NOT NULL DEFAULT '' COMMENT '制片地区，使用/分隔',
    languages       VARCHAR(255)     NULL COMMENT '语言',
    release_year    SMALLINT UNSIGNED NULL COMMENT '上映年份',
    release_date    DATE             NULL COMMENT '上映日期',
    mins            SMALLINT UNSIGNED NULL COMMENT '片长，分钟',
    storyline       TEXT             NULL COMMENT '剧情简介',
    score           DECIMAL(4,2)     NOT NULL DEFAULT 0.00 COMMENT '平均分，0到10',
    rating_count    INT UNSIGNED     NOT NULL DEFAULT 0 COMMENT '评分数量',
    popularity      BIGINT UNSIGNED  NOT NULL DEFAULT 0 COMMENT '热度值',
    status          VARCHAR(16)      NOT NULL DEFAULT 'AVAILABLE' COMMENT 'AVAILABLE/OFF_SHELF',
    created_at      DATETIME(6)      NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at      DATETIME(6)      NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
                                      ON UPDATE CURRENT_TIMESTAMP(6),
    PRIMARY KEY (id),
    UNIQUE KEY uk_movie_douban_id (douban_id),
    KEY idx_movie_filter (status, release_year, score),
    KEY idx_movie_hot (status, popularity DESC, score DESC),
    KEY idx_movie_name (name),
    CONSTRAINT chk_movie_score CHECK (score >= 0 AND score <= 10),
    CONSTRAINT chk_movie_status CHECK (status IN ('AVAILABLE', 'OFF_SHELF'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
  COMMENT='电影主数据表';
```

### 3.3 影院表

```sql
CREATE TABLE IF NOT EXISTS cinema (
    id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '影院ID',
    name            VARCHAR(128)     NOT NULL COMMENT '影院名称',
    address         VARCHAR(255)     NOT NULL COMMENT '详细地址',
    city            VARCHAR(64)      NOT NULL COMMENT '所在城市',
    status          VARCHAR(16)      NOT NULL DEFAULT 'OPEN' COMMENT 'OPEN/CLOSED',
    created_at      DATETIME(6)      NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at      DATETIME(6)      NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
                                      ON UPDATE CURRENT_TIMESTAMP(6),
    PRIMARY KEY (id),
    KEY idx_cinema_city_status (city, status),
    CONSTRAINT chk_cinema_status CHECK (status IN ('OPEN', 'CLOSED'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
  COMMENT='影院表';
```

### 3.4 电影场次表

```sql
CREATE TABLE IF NOT EXISTS movie_schedule (
    id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '场次ID',
    movie_id        BIGINT UNSIGNED NOT NULL COMMENT '电影ID',
    cinema_id       BIGINT UNSIGNED NOT NULL COMMENT '影院ID',
    hall_name       VARCHAR(64)      NOT NULL COMMENT '影厅名称',
    start_time      DATETIME(6)      NOT NULL COMMENT '开场时间，UTC',
    end_time        DATETIME(6)      NOT NULL COMMENT '结束时间，UTC',
    price           DECIMAL(10,2)    NOT NULL COMMENT '单座票价',
    status          VARCHAR(16)      NOT NULL DEFAULT 'ON_SALE'
                                     COMMENT 'ON_SALE/STOPPED/FINISHED',
    created_at      DATETIME(6)      NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at      DATETIME(6)      NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
                                      ON UPDATE CURRENT_TIMESTAMP(6),
    PRIMARY KEY (id),
    KEY idx_schedule_movie_time (movie_id, status, start_time),
    KEY idx_schedule_cinema_time (cinema_id, status, start_time),
    CONSTRAINT fk_schedule_movie
        FOREIGN KEY (movie_id) REFERENCES movie (id)
        ON UPDATE RESTRICT ON DELETE RESTRICT,
    CONSTRAINT fk_schedule_cinema
        FOREIGN KEY (cinema_id) REFERENCES cinema (id)
        ON UPDATE RESTRICT ON DELETE RESTRICT,
    CONSTRAINT chk_schedule_time CHECK (end_time > start_time),
    CONSTRAINT chk_schedule_price CHECK (price > 0),
    CONSTRAINT chk_schedule_status
        CHECK (status IN ('ON_SALE', 'STOPPED', 'FINISHED'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
  COMMENT='电影放映场次表';
```

### 3.5 订单表

订单表需要先于座位表建立，以便座位记录保存当前关联订单。

```sql
CREATE TABLE IF NOT EXISTS ticket_order (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '订单ID',
    order_no            VARCHAR(40)      NOT NULL COMMENT '业务订单号',
    user_id             BIGINT UNSIGNED NOT NULL COMMENT '下单用户ID',
    schedule_id         BIGINT UNSIGNED NOT NULL COMMENT '场次ID',
    total_amount        DECIMAL(10,2)    NOT NULL COMMENT '订单总金额快照',
    status              VARCHAR(24)      NOT NULL DEFAULT 'PENDING_PAYMENT'
                                         COMMENT '订单状态',
    idempotency_key     VARCHAR(64)      NOT NULL COMMENT '客户端幂等键',
    paid_at             DATETIME(6)      NULL COMMENT '支付成功时间',
    refunded_at         DATETIME(6)      NULL COMMENT '退款成功时间',
    created_at          DATETIME(6)      NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at          DATETIME(6)      NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
                                          ON UPDATE CURRENT_TIMESTAMP(6),
    PRIMARY KEY (id),
    UNIQUE KEY uk_order_no (order_no),
    UNIQUE KEY uk_order_user_idempotency (user_id, idempotency_key),
    KEY idx_order_user_status_time (user_id, status, created_at),
    KEY idx_order_schedule (schedule_id),
    CONSTRAINT fk_order_user
        FOREIGN KEY (user_id) REFERENCES app_user (id)
        ON UPDATE RESTRICT ON DELETE RESTRICT,
    CONSTRAINT fk_order_schedule
        FOREIGN KEY (schedule_id) REFERENCES movie_schedule (id)
        ON UPDATE RESTRICT ON DELETE RESTRICT,
    CONSTRAINT chk_order_amount CHECK (total_amount >= 0),
    CONSTRAINT chk_order_status CHECK (
        status IN (
            'PENDING_PAYMENT', 'PAID', 'PAYMENT_FAILED',
            'CANCELLED', 'EXPIRED', 'REFUNDED'
        )
    )
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
  COMMENT='购票订单表';
```

### 3.6 场次座位表

```sql
CREATE TABLE IF NOT EXISTS schedule_seat (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '场次座位ID',
    schedule_id         BIGINT UNSIGNED NOT NULL COMMENT '场次ID',
    seat_row            VARCHAR(8)      NOT NULL COMMENT '排号，例如A',
    seat_number         SMALLINT UNSIGNED NOT NULL COMMENT '座位序号',
    status              VARCHAR(16)     NOT NULL DEFAULT 'AVAILABLE'
                                         COMMENT 'AVAILABLE/LOCKED/SOLD',
    lock_user_id        BIGINT UNSIGNED NULL COMMENT '当前锁座用户ID',
    lock_expires_at     DATETIME(6)     NULL COMMENT '锁定过期时间',
    order_id            BIGINT UNSIGNED NULL COMMENT '当前关联订单ID',
    created_at          DATETIME(6)     NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at          DATETIME(6)     NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
                                         ON UPDATE CURRENT_TIMESTAMP(6),
    PRIMARY KEY (id),
    UNIQUE KEY uk_schedule_seat (schedule_id, seat_row, seat_number),
    KEY idx_seat_schedule_status (schedule_id, status),
    KEY idx_seat_lock_cleanup (status, lock_expires_at),
    KEY idx_seat_lock_user (lock_user_id, status),
    KEY idx_seat_order (order_id),
    CONSTRAINT fk_seat_schedule
        FOREIGN KEY (schedule_id) REFERENCES movie_schedule (id)
        ON UPDATE RESTRICT ON DELETE CASCADE,
    CONSTRAINT fk_seat_lock_user
        FOREIGN KEY (lock_user_id) REFERENCES app_user (id)
        ON UPDATE RESTRICT ON DELETE SET NULL,
    CONSTRAINT fk_seat_order
        FOREIGN KEY (order_id) REFERENCES ticket_order (id)
        ON UPDATE RESTRICT ON DELETE SET NULL,
    CONSTRAINT chk_seat_number CHECK (seat_number > 0),
    CONSTRAINT chk_seat_status
        CHECK (status IN ('AVAILABLE', 'LOCKED', 'SOLD'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
  COMMENT='每个场次的座位库存表';
```

这里不对 `lock_user_id` 建立跨字段 `CHECK` 约束。该列的外键使用了
`ON DELETE SET NULL`，MySQL 禁止外键级联动作修改被 `CHECK` 表达式引用的列，
否则会在建表时产生错误 3823。座位状态与锁定字段的一致性由 FastAPI
锁座事务和超时清理任务维护，`chk_seat_status` 仍负责限制合法状态值。

如果之前已经执行过包含 `chk_seat_lock_fields` 的版本且表创建失败，直接重新
执行上面的完整 `CREATE TABLE` 即可。如果表已经存在并包含该约束，可以执行：

```sql
ALTER TABLE schedule_seat
    DROP CHECK chk_seat_lock_fields;
```

### 3.7 订单座位明细表

```sql
CREATE TABLE IF NOT EXISTS order_seat (
    id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '订单座位明细ID',
    order_id        BIGINT UNSIGNED NOT NULL COMMENT '订单ID',
    seat_id         BIGINT UNSIGNED NOT NULL COMMENT '场次座位ID',
    price           DECIMAL(10,2)    NOT NULL COMMENT '下单时单座价格快照',
    PRIMARY KEY (id),
    UNIQUE KEY uk_order_seat (order_id, seat_id),
    KEY idx_order_seat_seat (seat_id),
    CONSTRAINT fk_order_seat_order
        FOREIGN KEY (order_id) REFERENCES ticket_order (id)
        ON UPDATE RESTRICT ON DELETE CASCADE,
    CONSTRAINT fk_order_seat_seat
        FOREIGN KEY (seat_id) REFERENCES schedule_seat (id)
        ON UPDATE RESTRICT ON DELETE RESTRICT,
    CONSTRAINT chk_order_seat_price CHECK (price >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
  COMMENT='订单座位及价格快照';
```

### 3.8 支付事件表

```sql
CREATE TABLE IF NOT EXISTS payment_event (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '支付事件ID',
    order_id            BIGINT UNSIGNED NOT NULL COMMENT '订单ID',
    provider_trade_no   VARCHAR(64)      NOT NULL COMMENT '支付平台流水号',
    event_type          VARCHAR(16)      NOT NULL DEFAULT 'PAY' COMMENT 'PAY/REFUND',
    success             BOOLEAN          NOT NULL COMMENT '事件是否成功',
    signature_valid     BOOLEAN          NOT NULL DEFAULT FALSE COMMENT '签名是否验证通过',
    processed_status    VARCHAR(16)      NOT NULL DEFAULT 'PROCESSED'
                                         COMMENT 'RECEIVED/PROCESSED/FAILED',
    raw_payload         JSON             NULL COMMENT '原始回调内容',
    failure_reason      VARCHAR(500)     NULL COMMENT '处理失败原因',
    processed_at        DATETIME(6)      NULL COMMENT '完成处理时间',
    created_at          DATETIME(6)      NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    PRIMARY KEY (id),
    UNIQUE KEY uk_payment_trade_no (provider_trade_no),
    KEY idx_payment_order_time (order_id, created_at),
    CONSTRAINT fk_payment_order
        FOREIGN KEY (order_id) REFERENCES ticket_order (id)
        ON UPDATE RESTRICT ON DELETE RESTRICT,
    CONSTRAINT chk_payment_event_type CHECK (event_type IN ('PAY', 'REFUND')),
    CONSTRAINT chk_payment_processed_status
        CHECK (processed_status IN ('RECEIVED', 'PROCESSED', 'FAILED'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
  COMMENT='支付与退款回调事件表';
```

> 当前 FastAPI 实体只使用了 `order_id`、`provider_trade_no`、`success` 和 `created_at`。其余字段为生产化预留字段，不影响现有查询，但写入生产支付回调时应补齐。

### 3.9 评分评论表

```sql
CREATE TABLE IF NOT EXISTS movie_review (
    id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '评论ID',
    user_id         BIGINT UNSIGNED NOT NULL COMMENT '用户ID',
    movie_id        BIGINT UNSIGNED NOT NULL COMMENT '电影ID',
    rating          DECIMAL(3,1)    NOT NULL COMMENT '评分，1到10',
    content         VARCHAR(1000)    NOT NULL COMMENT '评论内容',
    created_at      DATETIME(6)     NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at      DATETIME(6)     NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
                                     ON UPDATE CURRENT_TIMESTAMP(6),
    PRIMARY KEY (id),
    UNIQUE KEY uk_review_user_movie (user_id, movie_id),
    KEY idx_review_movie_time (movie_id, created_at),
    KEY idx_review_user_rating (user_id, rating),
    CONSTRAINT fk_review_user
        FOREIGN KEY (user_id) REFERENCES app_user (id)
        ON UPDATE RESTRICT ON DELETE RESTRICT,
    CONSTRAINT fk_review_movie
        FOREIGN KEY (movie_id) REFERENCES movie (id)
        ON UPDATE RESTRICT ON DELETE RESTRICT,
    CONSTRAINT chk_review_rating CHECK (rating >= 1 AND rating <= 10),
    CONSTRAINT chk_review_content CHECK (CHAR_LENGTH(TRIM(content)) > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
  COMMENT='用户评分评论表';
```

## 4. 保留的统计聚合表

统计表由离线数据处理或定时任务刷新。业务接口只读取，不应在购票事务中更新这些表。

### 4.1 演员参演电影 Top50

```sql
CREATE TABLE IF NOT EXISTS stat_actor_top50 (
    person_name       VARCHAR(255)    NOT NULL COMMENT '演员名',
    acted_movie_cnt   BIGINT UNSIGNED NOT NULL COMMENT '参演电影数量',
    rank_no           SMALLINT UNSIGNED NULL COMMENT '排名',
    refreshed_at      DATETIME(6)     NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    PRIMARY KEY (person_name),
    UNIQUE KEY uk_actor_rank (rank_no),
    KEY idx_actor_movie_count (acted_movie_cnt DESC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
  COMMENT='演员参演电影数量Top50';
```

### 4.2 地区年份平均评分

原 Java 实体只将 `region_name` 标记为主键，会导致同一地区不同年份发生冲突。这里改为正确的联合主键。

```sql
CREATE TABLE IF NOT EXISTS stat_region_year_avg_score (
    region_name        VARCHAR(100)      NOT NULL COMMENT '地区',
    movie_year         SMALLINT UNSIGNED NOT NULL COMMENT '电影年份',
    region_score_avg   DECIMAL(5,2)      NOT NULL COMMENT '地区年份平均评分',
    movie_count        BIGINT UNSIGNED   NOT NULL DEFAULT 0 COMMENT '参与统计的电影数',
    refreshed_at       DATETIME(6)       NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    PRIMARY KEY (region_name, movie_year),
    KEY idx_region_year_score (movie_year, region_score_avg DESC),
    CONSTRAINT chk_region_year_avg_score
        CHECK (region_score_avg >= 0 AND region_score_avg <= 10)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
  COMMENT='地区年份平均评分统计';
```

### 4.3 年份地区电影数量

原 Java 实体只将 `movie_year` 标记为主键。这里使用 `movie_year + region_name` 联合主键，允许同一年保存多个地区。

```sql
CREATE TABLE IF NOT EXISTS stat_year_region_count (
    movie_year          SMALLINT UNSIGNED NOT NULL COMMENT '电影年份',
    region_name         VARCHAR(100)      NOT NULL COMMENT '地区',
    region_year_count   BIGINT UNSIGNED   NOT NULL COMMENT '电影数量',
    refreshed_at        DATETIME(6)       NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    PRIMARY KEY (movie_year, region_name),
    KEY idx_year_region_count (movie_year, region_year_count DESC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
  COMMENT='年份地区电影数量统计';
```

### 4.4 年份电影 Top20

原 Java 实体只将 `movie_year` 标记为主键，无法保存同一年 20 部电影。这里改为 `movie_year + movie_id` 联合主键。

```sql
CREATE TABLE IF NOT EXISTS stat_year_top20_movie (
    movie_year      SMALLINT UNSIGNED NOT NULL COMMENT '电影年份',
    movie_id        VARCHAR(32)       NOT NULL COMMENT '豆瓣电影ID',
    name            VARCHAR(255)      NOT NULL COMMENT '电影名称',
    douban_score    DECIMAL(4,2)      NOT NULL COMMENT '豆瓣评分',
    douban_votes    VARCHAR(32)       NULL COMMENT '豆瓣评分人数',
    rank_no         TINYINT UNSIGNED  NULL COMMENT '年份内排名1到20',
    refreshed_at    DATETIME(6)       NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    PRIMARY KEY (movie_year, movie_id),
    UNIQUE KEY uk_year_top20_rank (movie_year, rank_no),
    KEY idx_year_top20_score (movie_year, douban_score DESC),
    CONSTRAINT chk_year_top20_score
        CHECK (douban_score >= 0 AND douban_score <= 10),
    CONSTRAINT chk_year_top20_rank
        CHECK (rank_no IS NULL OR (rank_no >= 1 AND rank_no <= 20))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
  COMMENT='每年评分Top20电影';
```

## 5. 简单统计的处理方式

本项目定位是“电影购票接口自动化测试”，不再维护简单或重复的统计物理表和视图：

- `/api/stat/high-score-average` 直接对 `movie.score` 做 `AVG`；
- `/api/stat/mins-summary` 直接对 `movie.mins` 做 `MAX/MIN/AVG`；
- 类型、语言、单维年份、单维地区、评分区间、年份平均片长和地区 Top50 接口已删除。

这样可以减少导入失败、数据过期、重复口径和测试维护成本。复杂二维统计及 TopN 结果仍保留物理表。

## 6. 统计表刷新 SQL 示例

以下语句演示如何从 `movie` 主表刷新年份 Top20。其他三张复杂统计表通常由离线 Spark 任务或经过清洗的中间表导入。

### 6.1 年份 Top20 电影（MySQL 8 窗口函数）

```sql
START TRANSACTION;

DELETE FROM stat_year_top20_movie;

INSERT INTO stat_year_top20_movie
    (movie_year, movie_id, name, douban_score, douban_votes, rank_no, refreshed_at)
SELECT
    release_year,
    douban_id,
    name,
    score,
    CAST(rating_count AS CHAR),
    rank_no,
    UTC_TIMESTAMP(6)
FROM (
    SELECT
        release_year,
        douban_id,
        name,
        score,
        rating_count,
        ROW_NUMBER() OVER (
            PARTITION BY release_year
            ORDER BY score DESC, rating_count DESC, id ASC
        ) AS rank_no
    FROM movie
    WHERE release_year IS NOT NULL
      AND douban_id IS NOT NULL
      AND status = 'AVAILABLE'
) ranked
WHERE rank_no <= 20;

COMMIT;
```

## 7. 锁座超时清理 SQL

建议由定时任务每分钟执行。必须先把待支付订单标记为过期，再释放座位。

```sql
START TRANSACTION;

UPDATE ticket_order o
JOIN schedule_seat s ON s.order_id = o.id
SET
    o.status = 'EXPIRED',
    o.updated_at = UTC_TIMESTAMP(6)
WHERE o.status = 'PENDING_PAYMENT'
  AND s.status = 'LOCKED'
  AND s.lock_expires_at < UTC_TIMESTAMP(6);

UPDATE schedule_seat
SET
    status = 'AVAILABLE',
    lock_user_id = NULL,
    lock_expires_at = NULL,
    order_id = NULL,
    updated_at = UTC_TIMESTAMP(6)
WHERE status = 'LOCKED'
  AND lock_expires_at < UTC_TIMESTAMP(6);

COMMIT;
```

## 8. 应用账号与权限

不要让 FastAPI 使用 MySQL `root` 账号。请将示例密码替换为强密码。

```sql
CREATE USER IF NOT EXISTS 'cineflow'@'%'
    IDENTIFIED BY 'replace-with-a-strong-password';

GRANT SELECT, INSERT, UPDATE, DELETE
ON cineflow_db.* TO 'cineflow'@'%';

FLUSH PRIVILEGES;
```

FastAPI `.env` 配置示例：

```text
DATABASE_URL=mysql+pymysql://cineflow:replace-with-a-strong-password@127.0.0.1:3306/cineflow_db?charset=utf8mb4
AUTO_CREATE_TABLES=false
SEED_DEMO_DATA=false
```

生产环境建议关闭 SQLAlchemy 自动建表，后续使用 Alembic 管理数据库版本。

## 9. 建表结果检查

### 9.1 检查物理表

```sql
SELECT
    table_name,
    table_type
FROM information_schema.tables
WHERE table_schema = 'cineflow_db'
ORDER BY table_type, table_name;
```

预期核心业务表：

```text
app_user
movie
cinema
movie_schedule
ticket_order
schedule_seat
order_seat
payment_event
movie_review
```

预期统计物理表：

```text
stat_actor_top50
stat_region_year_avg_score
stat_year_region_count
stat_year_top20_movie
```

不再创建统计视图。查询结果应为 13 张 `BASE TABLE`、0 个统计视图。

### 9.2 检查外键

```sql
SELECT
    table_name,
    constraint_name,
    referenced_table_name
FROM information_schema.referential_constraints
WHERE constraint_schema = 'cineflow_db'
ORDER BY table_name, constraint_name;
```

### 9.3 检查索引

```sql
SELECT
    table_name,
    index_name,
    GROUP_CONCAT(column_name ORDER BY seq_in_index) AS columns_in_index,
    non_unique
FROM information_schema.statistics
WHERE table_schema = 'cineflow_db'
GROUP BY table_name, index_name, non_unique
ORDER BY table_name, index_name;
```

## 10. 与当前 FastAPI 代码的兼容注意事项

执行这套 SQL 后，还需要注意两处代码差异：

1. `movie` 表新增了 `douban_id`，建议在 SQLAlchemy `Movie` 实体中增加对应字段；
2. `payment_event` 增加了生产化审计字段，但均提供默认值或允许为空，现有支付代码仍可插入基础字段；
3. FastAPI 只映射 4 张统计物理表，高分均值与片长汇总由 `movie` 实时聚合。

如果使用本 SQL 管理正式 MySQL 数据库，应设置：

```text
AUTO_CREATE_TABLES=false
```

避免 SQLAlchemy `create_all()` 与正式数据库迁移流程混用。并发抢座测试必须使用 MySQL/InnoDB；SQLite 只适合普通接口功能测试，不能完整验证 `SELECT ... FOR UPDATE` 行锁行为。
