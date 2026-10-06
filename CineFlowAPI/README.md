# CineFlowAPI（影流电影票务与推荐系统）

`CineFlow` 表示电影从发现、推荐、选座、购票到评价的数据与业务流。项目参照原 Java 工程的 Controller / Service / Entity / Mapper 分层，使用 FastAPI + SQLAlchemy 实现《电影项目自动化测试平台建设大纲》第 5 节全部重点业务模块。

## 已实现模块

- 用户注册、重复校验、scrypt 密码哈希、HS256 JWT、token 过期/伪造校验、RBAC。
- 电影分页、类型/地区/年份/评分筛选、详情、热门榜单。
- 影院、场次、座位图、锁座和超时释放。
- 幂等下单、数据库行锁防超卖、取消、支付成功/失败幂等回调、退款。
- 已购票用户评分评论、1~10 分校验、评论更新/删除、电影均分回写。
- 冷启动热门推荐、高评分类型偏好推荐、下架过滤、去重和热门兜底。
- 演员 Top50、地区/年份/类型/评分区间、高分均值、片长、年份 Top20 统计。

## 本地运行

```powershell
cd CineFlowAPI
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
uvicorn app.main:app --reload
```

默认使用 SQLite 并写入演示数据。接口文档：`http://127.0.0.1:8000/docs`。

演示账号：

- 管理员：`admin / Admin123`
- 普通用户：`test_user / Test1234`

## MySQL / Docker

```powershell
docker compose up --build
```

也可复制 `.env.example` 为 `.env`，将 `DATABASE_URL` 设置为：

```text
mysql+pymysql://root:root@127.0.0.1:3306/cineflow_db?charset=utf8mb4
```

生产环境必须替换 `JWT_SECRET`，并建议关闭 `AUTO_CREATE_TABLES` 和 `SEED_DEMO_DATA`，改用正式迁移工具维护表结构。

## 测试

```powershell
.\.venv\Scripts\python.exe -m pytest
```

测试覆盖鉴权、重复注册、筛选分页、幂等订单、座位冲突、支付、评分边界、推荐规则与统计接口。

## 主要接口

| 模块 | 接口 |
|---|---|
| 用户 | `POST /api/auth/register`、`POST /api/auth/login` |
| 电影 | `GET /api/movies`、`GET /api/movies/{id}`、`GET /api/movies/hot` |
| 场次座位 | `GET /api/movies/{id}/schedules`、`GET /api/schedules/{id}/seats`、`POST .../lock` |
| 订单 | `POST /api/orders`、`POST /api/orders/{id}/cancel`、`payment-callback`、`refund` |
| 评论 | `PUT/GET /api/movies/{id}/reviews`、`DELETE /api/reviews/{id}` |
| 推荐 | `GET /api/recommendations/hot`、`GET /api/recommendations/me` |
| 统计 | `GET /api/stat/*` |
| 管理 | `POST /api/admin/movies`、`cinemas`、`schedules` |
