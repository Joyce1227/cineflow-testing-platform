# CineFlow 数据库 13 表快速掌握说明

这份文档按当前项目改造后的口径编写：数据库只保留 **13 张物理表**。

- 9 张核心业务表：真正支撑电影购票、锁座、支付、退款、评论和推荐。
- 4 张统计聚合表：只保留复杂、常用、能体现电影数据分析价值的统计结果。
- 2 个简单统计接口：不再建表，直接从 `movie` 表实时计算。

面试时可以这样讲：我的项目重点是“电影购票接口自动化测试”，所以数据库设计以购票链路的一致性为核心，统计模块只保留少量有业务展示价值的聚合结果，避免为了凑表而增加维护成本。

## 一、13 张表总览

```text
cineflow_db
├─ 用户与权限
│  └─ app_user
├─ 电影与影院
│  ├─ movie
│  ├─ cinema
│  └─ movie_schedule
├─ 座位与订单
│  ├─ schedule_seat
│  ├─ ticket_order
│  ├─ order_seat
│  └─ payment_event
├─ 评论与推荐
│  └─ movie_review
└─ 统计分析
   ├─ stat_actor_top50
   ├─ stat_region_year_avg_score
   ├─ stat_year_region_count
   └─ stat_year_top20_movie
```

最重要的是先掌握 9 张业务表。4 张统计表没有外键，可以把它们理解成“提前算好的报表结果”。

## 二、核心关系一句话版

用户 `app_user` 买某个场次 `movie_schedule` 的座位 `schedule_seat`，系统生成订单 `ticket_order`，订单包含多个座位明细 `order_seat`，支付回调记录到 `payment_event`，支付成功后座位变成 `SOLD`。用户买过票后可以给电影 `movie` 写评论 `movie_review`。

```text
app_user
  ├─ ticket_order
  │    ├─ order_seat
  │    │    └─ schedule_seat
  │    └─ payment_event
  └─ movie_review

movie
  ├─ movie_schedule
  │    └─ schedule_seat
  └─ movie_review

cinema
  └─ movie_schedule
```

## 三、主键和外键速查

| 表名 | 主键 | 外键连向 | 业务含义 |
|---|---|---|---|
| `app_user` | `id` | 无 | 系统用户，含普通用户和管理员 |
| `movie` | `id` | 无 | 电影基础信息 |
| `cinema` | `id` | 无 | 影院基础信息 |
| `movie_schedule` | `id` | `movie_id -> movie.id`；`cinema_id -> cinema.id` | 某电影在某影院某影厅的放映场次 |
| `schedule_seat` | `id` | `schedule_id -> movie_schedule.id`；`lock_user_id -> app_user.id` | 某一场次下的一张座位库存 |
| `ticket_order` | `id` | `user_id -> app_user.id`；`schedule_id -> movie_schedule.id` | 用户订单主表 |
| `order_seat` | `id` | `order_id -> ticket_order.id`；`seat_id -> schedule_seat.id` | 订单买了哪些座位 |
| `payment_event` | `id` | `order_id -> ticket_order.id` | 支付平台回调事件 |
| `movie_review` | `id` | `user_id -> app_user.id`；`movie_id -> movie.id` | 用户对电影的评分评论 |
| `stat_actor_top50` | `person_name` | 无 | 演员参演电影数 Top50 |
| `stat_region_year_avg_score` | `(region_name, movie_year)` | 无 | 地区 + 年份维度的平均评分 |
| `stat_year_region_count` | `(movie_year, region_name)` | 无 | 年份 + 地区维度的电影数量 |
| `stat_year_top20_movie` | `(movie_year, movie_id)` | 无 | 每年评分 Top20 电影 |

注意：统计表不设外键是有意设计。它们可能来自离线数据集、Hive/Spark、CSV 或旧 Java 项目，不一定完全对应在线 `movie.id`。

## 四、9 张业务表怎么记

### 1. `app_user`

这是用户表。

关键字段：

| 字段 | 作用 |
|---|---|
| `id` | 用户主键 |
| `username` | 登录名，唯一 |
| `phone` | 手机号，唯一 |
| `email` | 邮箱，唯一 |
| `password_hash` | 密码哈希，不保存明文 |
| `role` | `USER` 或 `ADMIN` |
| `status` | `ACTIVE` 或 `DISABLED` |

它会被三张表引用：

- `ticket_order.user_id`
- `schedule_seat.lock_user_id`
- `movie_review.user_id`

面试表达：用户表不只用于登录，还参与订单归属、锁座归属和评论归属。

### 2. `movie`

这是电影主表。

关键字段：

| 字段 | 作用 |
|---|---|
| `id` | 系统内部电影 ID |
| `name` | 电影名称 |
| `genres` | 类型，如 `科幻/剧情` |
| `regions` | 地区，如 `中国大陆/美国` |
| `languages` | 语言 |
| `release_year` | 上映年份 |
| `mins` | 片长 |
| `score` | 当前评分 |
| `rating_count` | 评分人数 |
| `popularity` | 热度 |
| `status` | `AVAILABLE` 或 `OFF_SHELF` |

它会被两张表引用：

- `movie_schedule.movie_id`
- `movie_review.movie_id`

面试表达：电影表支撑列表筛选、热门推荐、场次查询、评论评分和简单统计。

### 3. `cinema`

这是影院表。

关键字段：

| 字段 | 作用 |
|---|---|
| `id` | 影院 ID |
| `name` | 影院名称 |
| `city` | 城市 |
| `address` | 地址 |
| `status` | `OPEN` 或 `CLOSED` |

它会被 `movie_schedule.cinema_id` 引用。

### 4. `movie_schedule`

这是场次表。它把电影和影院连起来。

关键字段：

| 字段 | 作用 |
|---|---|
| `id` | 场次 ID |
| `movie_id` | 关联电影 |
| `cinema_id` | 关联影院 |
| `hall_name` | 影厅 |
| `start_time` | 开场时间 |
| `end_time` | 结束时间 |
| `price` | 单座价格 |
| `status` | `ON_SALE`、`STOPPED`、`FINISHED` |

它会被两张表引用：

- `schedule_seat.schedule_id`
- `ticket_order.schedule_id`

面试表达：场次是购票链路的入口。没有场次，就没有座位库存，也不能下单。

### 5. `schedule_seat`

这是最关键的库存表。每个场次都会生成一批自己的座位。

关键字段：

| 字段 | 作用 |
|---|---|
| `id` | 场次座位 ID |
| `schedule_id` | 所属场次 |
| `seat_row` | 排号 |
| `seat_number` | 座位号 |
| `status` | `AVAILABLE`、`LOCKED`、`SOLD` |
| `lock_user_id` | 当前锁座用户 |
| `lock_expires_at` | 锁座过期时间 |
| `order_id` | 当前关联订单 |

核心唯一约束：

```sql
UNIQUE KEY uk_schedule_seat (schedule_id, seat_row, seat_number)
```

这表示同一个场次里不能出现两个 A1 座位。

面试表达：防超卖的核心不在前端，而在数据库事务锁定 `schedule_seat` 行，并校验座位状态。

### 6. `ticket_order`

这是订单主表。

关键字段：

| 字段 | 作用 |
|---|---|
| `id` | 订单 ID |
| `order_no` | 对外订单号，唯一 |
| `user_id` | 下单用户 |
| `schedule_id` | 购买场次 |
| `total_amount` | 总金额快照 |
| `status` | 订单状态 |
| `idempotency_key` | 幂等键 |
| `paid_at` | 支付时间 |
| `refunded_at` | 退款时间 |

关键唯一约束：

```sql
UNIQUE KEY uk_user_idempotency (user_id, idempotency_key)
```

这表示同一个用户用同一个幂等键重复下单，只能得到同一笔订单，不能重复创建。

### 7. `order_seat`

这是订单和座位的中间表。

为什么需要它？因为一个订单可以包含多个座位，一张座位也需要留下被哪个订单购买过的记录。

关键字段：

| 字段 | 作用 |
|---|---|
| `id` | 明细 ID |
| `order_id` | 订单 ID |
| `seat_id` | 座位 ID |
| `price` | 下单时单座价格快照 |

核心唯一约束：

```sql
UNIQUE KEY uk_order_seat (order_id, seat_id)
```

面试表达：价格放在明细表里是为了保存下单当时的价格快照，避免后续场次调价影响历史订单。

### 8. `payment_event`

这是支付事件表。

关键字段：

| 字段 | 作用 |
|---|---|
| `id` | 支付事件 ID |
| `order_id` | 对应订单 |
| `provider_trade_no` | 第三方支付流水号，唯一 |
| `success` | 回调是否成功 |
| `created_at` | 回调时间 |

核心唯一约束：

```sql
UNIQUE KEY uk_payment_provider_trade (provider_trade_no)
```

面试表达：支付回调可能重复到达，所以必须用支付流水号做幂等控制。重复回调不能重复改订单、重复卖座。

### 9. `movie_review`

这是评分评论表。

关键字段：

| 字段 | 作用 |
|---|---|
| `id` | 评论 ID |
| `user_id` | 评论用户 |
| `movie_id` | 被评论电影 |
| `rating` | 评分 |
| `content` | 评论内容 |

核心唯一约束：

```sql
UNIQUE KEY uk_review_user_movie (user_id, movie_id)
```

这表示一个用户对一部电影只保留一条评论，再次评论就是修改。

面试表达：项目里还会校验用户是否买过票，只有购票后才允许评论，避免刷评论。

## 五、4 张统计聚合表

这 4 张表服务于“电影数据统计展示”，不是购票链路核心表。

| 表名 | 主键 | 接口 | 为什么保留 |
|---|---|---|---|
| `stat_actor_top50` | `person_name` | `GET /api/stat/actor-top50` | TopN 排行榜，适合提前算好 |
| `stat_region_year_avg_score` | `(region_name, movie_year)` | `GET /api/stat/region-year-average-score` | 地区 + 年份 + 均分，维度组合较复杂 |
| `stat_year_region_count` | `(movie_year, region_name)` | `GET /api/stat/year-region-count` | 年份 + 地区交叉统计，适合图表 |
| `stat_year_top20_movie` | `(movie_year, movie_id)` | `GET /api/stat/year-top20` | 每年 Top20，排序和分组成本较高 |

以下简单统计已经删除物理表：

| 已删除对象 | 处理方式 |
|---|---|
| `stat_genre_count` | 如需展示，可从 `movie.genres` 实时统计或后续再建 |
| `stat_language` | 如需展示，可从 `movie.languages` 实时统计 |
| `stat_movie_year` | 如需展示，可按 `movie.release_year` 实时 `GROUP BY` |
| `stat_region_count` | 如需展示，可从 `movie.regions` 实时统计 |
| `stat_score_section` | 如需展示，可用 `CASE WHEN` 实时分段 |
| `stat_year_avg_mins` | 如需展示，可按 `movie.release_year` 实时聚合 |
| `stat_region_top50` | 原本只是地区统计排序结果，重复 |
| `stat_high_score_avg` | 改成 `/api/stat/high-score-average` 实时计算 |
| `stat_mins_total` | 改成 `/api/stat/mins-summary` 实时计算 |

当前统计模块共有 6 个接口：

| 接口 | 数据来源 |
|---|---|
| `/api/stat/actor-top50` | `stat_actor_top50` |
| `/api/stat/year-top20` | `stat_year_top20_movie` |
| `/api/stat/region-year-average-score` | `stat_region_year_avg_score` |
| `/api/stat/year-region-count` | `stat_year_region_count` |
| `/api/stat/high-score-average` | 实时查询 `movie` |
| `/api/stat/mins-summary` | 实时查询 `movie` |

## 六、购票核心链路

### 1. 看电影列表

读 `movie`。

### 2. 选电影看场次

读 `movie_schedule`，同时关联 `movie` 和 `cinema`。

### 3. 查看座位

读 `schedule_seat`。

### 4. 锁座

更新 `schedule_seat`：

```text
AVAILABLE -> LOCKED
```

同时写入：

- `lock_user_id`
- `lock_expires_at`

### 5. 创建订单

写入：

- `ticket_order`
- `order_seat`

同时继续保持座位为 `LOCKED`。

### 6. 支付成功

写入：

- `payment_event`

更新：

```text
ticket_order.status: PENDING_PAYMENT -> PAID
schedule_seat.status: LOCKED -> SOLD
```

### 7. 退款成功

更新：

```text
ticket_order.status: PAID -> REFUNDED
schedule_seat.status: SOLD -> AVAILABLE
```

## 七、状态机必须背熟

### 座位状态

```text
AVAILABLE 可售
    ↓ 锁座/下单
LOCKED 已锁
    ↓ 支付成功
SOLD 已售
```

异常分支：

- 锁座过期：`LOCKED -> AVAILABLE`
- 取消订单：`LOCKED -> AVAILABLE`
- 退款成功：`SOLD -> AVAILABLE`

### 订单状态

```text
PENDING_PAYMENT 待支付
    ├─ 支付成功 -> PAID
    ├─ 支付失败 -> PAYMENT_FAILED
    ├─ 用户取消 -> CANCELLED
    └─ 超时未支付 -> EXPIRED

PAID
    └─ 退款成功 -> REFUNDED
```

面试高频点：非法状态流转要返回 `409 Conflict`。例如订单已经 `PAID`，再次支付就不应该返回成功，因为这不是服务器故障，而是业务状态冲突。

## 八、自动化测试时重点测什么

| 模块 | 重点测试点 | 涉及表 |
|---|---|---|
| 注册登录 | 成功注册、重复注册、错误密码、Token 失效 | `app_user` |
| 电影查询 | 筛选、分页、详情、热门榜单 | `movie` |
| 场次座位 | 场次存在、座位生成、座位状态正确 | `movie_schedule`、`schedule_seat` |
| 锁座下单 | 座位不可重复锁、幂等下单、金额正确 | `schedule_seat`、`ticket_order`、`order_seat` |
| 支付回调 | 支付成功、重复回调、状态同步 | `ticket_order`、`schedule_seat`、`payment_event` |
| 退款取消 | 取消待支付订单、退款已支付订单、释放座位 | `ticket_order`、`schedule_seat` |
| 评论推荐 | 买票后评论、重复评论更新、推荐不含下架电影 | `movie_review`、`movie` |
| 统计接口 | 聚合表有数据、字段结构正确、筛选条件正确 | 4 张 `stat_*` 表、`movie` |

## 九、常用 SQL 帮你快速看懂数据

查看一个订单买了哪些座位：

```sql
SELECT
    o.id AS order_id,
    o.order_no,
    o.status AS order_status,
    s.id AS seat_id,
    s.seat_row,
    s.seat_number,
    s.status AS seat_status
FROM ticket_order o
JOIN order_seat os ON os.order_id = o.id
JOIN schedule_seat s ON s.id = os.seat_id
WHERE o.id = 1;
```

查看某场次还有多少可售座位：

```sql
SELECT status, COUNT(*) AS seat_count
FROM schedule_seat
WHERE schedule_id = 1
GROUP BY status;
```

验证支付事件是否重复：

```sql
SELECT provider_trade_no, COUNT(*) AS cnt
FROM payment_event
GROUP BY provider_trade_no
HAVING COUNT(*) > 1;
```

验证电影评分是否和评论一致：

```sql
SELECT
    m.id,
    m.name,
    m.score AS movie_score,
    m.rating_count AS movie_rating_count,
    ROUND(AVG(r.rating), 2) AS review_avg,
    COUNT(r.id) AS review_count
FROM movie m
LEFT JOIN movie_review r ON r.movie_id = m.id
WHERE m.id = 1
GROUP BY m.id, m.name, m.score, m.rating_count;
```

检查当前保留的 4 张统计表是否有数据：

```sql
SELECT 'stat_actor_top50' AS table_name, COUNT(*) AS row_count FROM stat_actor_top50
UNION ALL
SELECT 'stat_region_year_avg_score', COUNT(*) FROM stat_region_year_avg_score
UNION ALL
SELECT 'stat_year_region_count', COUNT(*) FROM stat_year_region_count
UNION ALL
SELECT 'stat_year_top20_movie', COUNT(*) FROM stat_year_top20_movie;
```

## 十、面试官问你为什么删统计表，怎么答

可以这样说：

> 我最开始从原 Java 统计项目迁移了很多统计表，但后来发现我的主项目定位是电影购票接口自动化测试。过多简单统计表会分散重点，也会增加导入、维护和讲解成本。所以我保留了 4 张复杂且有展示价值的聚合表，例如年度 Top20、地区年份均分、年份地区数量和演员 Top50。像年份数量、语言数量、片长汇总这类简单统计，要么直接从 `movie` 表实时算，要么暂时不暴露。这样项目重点更清楚，也更符合测试岗位面试里对业务链路、状态机、并发和数据一致性的考察。

## 十一、学习顺序

最快掌握方式：

1. 先背 9 张核心业务表。
2. 再画出 `用户 -> 场次 -> 座位 -> 订单 -> 支付` 链路。
3. 重点理解 `schedule_seat.status` 和 `ticket_order.status`。
4. 最后把 4 张统计表当成独立报表结果记住。

一句话收尾：这个数据库不是为了“表多”，而是为了能证明你理解购票系统里最容易出问题的地方：库存、订单、支付、退款、幂等和并发一致性。
