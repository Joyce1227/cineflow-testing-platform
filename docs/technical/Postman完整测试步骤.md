# CineFlow 电影购票推荐系统 Postman 完整测试步骤

> 对应后端：`CineFlowAPI`  
> 默认地址：`http://127.0.0.1:8000`  
> Swagger：`http://127.0.0.1:8000/docs`  
> OpenAPI：`http://127.0.0.1:8000/openapi.json`

## 零、先确认你当前的 Postman 界面

如果左侧已经出现下面的结构，说明 OpenAPI 已经成功导入：

```text
COLLECTIONS
└─ CineFlowAPI - 影流电影票务与推荐系统
   ├─ api
   │  ├─ auth
   │  ├─ movies
   │  ├─ cinemas
   │  ├─ schedules
   │  ├─ orders
   │  ├─ reviews
   │  ├─ recommendations
   │  ├─ stat
   │  └─ admin
   └─ health
      └─ GET Health
```

这时不需要再手工建立 `00系统检查`、`01用户与鉴权` 等目录。OpenAPI 生成的目录就是后续要使用的 Collection。

截图中同时出现的手工请求“健康检查”属于重复请求，可以保留作为练习，也可以右键删除；自动生成的 `health → GET Health` 已经能够测试同一个接口。

### 0.1 Postman 五个区域分别做什么

打开一个具体请求后，界面主要分为：

```text
左侧：Collection、接口文件夹和请求
顶部：请求标签页
中间第一行：HTTP 方法 + URL 地址栏 + Send 按钮
中间下方：Params / Authorization / Headers / Body / Scripts / Settings
底部：响应 Body、状态码、响应时间和 Test Results
```

只有点击到具体请求，例如 `GET Health`、`POST Login`，中间才会显示 URL 地址栏。点击 Collection、Environment 或文件夹时不会显示请求地址栏。

### 0.2 本文约定的按钮名称

不同 Postman 版本的名称可能稍有区别：

| 本文名称 | 你的版本可能显示为 | 含义 |
|---|---|---|
| Pre-request | Before request | 请求发送前运行脚本 |
| Post-response | After response | 收到响应后运行断言和变量提取 |
| Tests | After response | 旧版本的响应后脚本名称 |
| Save | `Ctrl + S` | 保存当前请求修改 |
| Send | Send | 发送一次 HTTP 请求 |

本文提到 `Post-response` 时，你的界面应点击 **Scripts → After response**。

### 0.3 打开和发送一个请求的固定动作

以后每个接口都按照同一套动作操作：

1. 在左侧展开接口文件夹前面的 `>`。
2. 点击带绿色 `GET`、橙色 `POST`、蓝色 `PUT` 或红色 `DELETE` 的具体请求。
3. 中间顶部确认请求方法和 URL。
4. 有 Query 参数时点击 **Params** 填写。
5. 需要登录时点击 **Authorization** 配置 Bearer Token。
6. POST/PUT 请求点击 **Body → raw → JSON**，替换示例 JSON。
7. 需要动态变量时点击 **Scripts → Before request** 填写前置脚本。
8. 需要断言或保存返回值时点击 **Scripts → After response** 填写脚本。
9. 按 `Ctrl + S` 保存。
10. 点击 **Send**。
11. 在下方查看响应状态码和 **Body**。
12. 点击响应区域的 **Test Results**，确认断言显示 `PASS`。

如果修改后没有按 `Ctrl + S`，本次发送通常仍然有效，但重新打开请求后修改可能丢失。

### 0.4 如何判断测试是否成功

不要只看响应 Body，应同时检查四项：

1. HTTP 状态码符合预期，例如登录 200、注册 201、删除 204。
2. JSON 中的 `code` 符合预期，成功时是 0。
3. Test Results 中所有脚本显示 `PASS`。
4. 订单、支付、座位等关键接口还要在 DataGrip 中核对数据库。

### 0.5 OpenAPI 自动生成请求的名称

请求名称通常来自 FastAPI 函数名，可能是英文，也可能带路径。只要 URL 一致即可。常见对应关系：

| 左侧文件夹 | 可能看到的请求名 | 实际接口 |
|---|---|---|
| `auth` | Register | `POST /api/auth/register` |
| `auth` | Login | `POST /api/auth/login` |
| `movies` | Movies | `GET /api/movies` |
| `movies` | Hot Movies | `GET /api/movies/hot` |
| `movies` | Movie Detail | `GET /api/movies/{movie_id}` |
| `movies` | Movie Schedules | `GET /api/movies/{movie_id}/schedules` |
| `cinemas` | Cinemas | `GET /api/cinemas` |
| `schedules` | Schedule Seats | `GET /api/schedules/{schedule_id}/seats` |
| `schedules` | Lock Seats | `POST /api/schedules/{schedule_id}/seats/lock` |
| `orders` | Create Order | `POST /api/orders` |
| `orders` | List Orders | `GET /api/orders` |
| `orders` | Order Detail | `GET /api/orders/{order_id}` |
| `orders` | Cancel Order | `POST /api/orders/{order_id}/cancel` |
| `orders` | Payment Callback | `POST /api/orders/{order_id}/payment-callback` |
| `orders` | Refund Order | `POST /api/orders/{order_id}/refund` |
| `reviews` | Save Review | `PUT /api/movies/{movie_id}/reviews` |
| `reviews` | List Reviews | `GET /api/movies/{movie_id}/reviews` |
| `reviews` | Delete Review | `DELETE /api/reviews/{review_id}` |
| `recommendations` | Hot Recommendations | `GET /api/recommendations/hot` |
| `recommendations` | My Recommendations | `GET /api/recommendations/me` |
| `stat` | 各统计名称 | `GET /api/stat/*` |
| `admin` | Admin Health | `GET /api/admin/health` |
| `admin` | Create Movie/Cinema/Schedule | `POST /api/admin/*` |
| `health` | Health | `GET /health` |

### 0.6 OpenAPI 中的路径变量怎么填

自动生成的 URL 可能显示：

```text
{{baseUrl}}/api/movies/:movie_id
```

或者：

```text
{{baseUrl}}/api/movies/{{movie_id}}
```

两种方式都可以。推荐统一改成本文使用的环境变量：

```text
{{base_url}}/api/movies/{{movie_id}}
```

如果保留 `:movie_id`：

1. 点击请求的 **Params**。
2. 找到下方 **Path Variables**。
3. 在 `movie_id` 的 Value 中填写 `{{movie_id}}`。

`schedule_id`、`order_id`、`review_id` 同理。

### 0.7 `baseUrl` 与 `base_url` 的区别

OpenAPI 自动生成的请求常使用 `{{baseUrl}}`，本文环境使用 `{{base_url}}`。变量名称区分大小写和下划线，两者不是同一个变量。

最快的解决办法是在 `CineFlow Local` 环境中同时保留两个变量：

| Variable | Value |
|---|---|
| `base_url` | `http://127.0.0.1:8000` |
| `baseUrl` | `http://127.0.0.1:8000` |

这样无需逐个修改 OpenAPI 自动生成的请求。鼠标放到 URL 中的变量上，如果弹窗显示当前值为 `http://127.0.0.1:8000`，说明变量已经生效；如果变量显示红色，说明当前环境中没有该变量。

### 0.8 第一次使用时严格按这个顺序

不要一开始就测试订单，第一次只完成下面七步：

1. 选择右上角环境 `CineFlow Local`。
2. 展开左侧 `health`，发送 `GET Health`。
3. 展开 `api → auth`，发送普通用户 `POST Login` 并保存 `user_token`。
4. 展开 `api → movies`，发送电影列表并保存 `movie_id`。
5. 发送电影场次并保存 `schedule_id`。
6. 展开 `api → schedules`，发送座位列表并保存 `seat_id`。
7. 前六步都成功后，再进入购票订单主链路。

## 一、测试目标

使用 Postman 按真实业务顺序验证以下内容：

- 系统健康检查。
- 用户注册、登录、JWT 鉴权和权限控制。
- 电影查询、筛选、详情和热门榜单。
- 影院、场次和座位查询。
- 锁座、幂等下单、订单查询、取消、支付和退款。
- 已购票用户评分评论和推荐结果。
- 电影统计分析接口。
- 管理员创建电影、影院、场次和座位。
- 常见异常、边界和重复请求。
- 订单、支付、座位和评论的数据库一致性。

完整主链路：

```text
普通用户登录
  ↓ 保存 user_token
查询电影 → 保存 movie_id
  ↓
查询未来场次 → 保存 schedule_id
  ↓
查询可用座位 → 保存 seat_id
  ↓
锁座 LOCKED
  ↓
幂等创建订单 PENDING_PAYMENT → 保存 order_id
  ↓
支付成功 PAID → 座位 SOLD
  ↓
评分评论 → 个性化推荐
  ↓
退款 REFUNDED → 座位 AVAILABLE
```

## 二、准备测试环境

### 2.1 启动后端

在 PowerShell 中执行：

```powershell
cd D:\MovieTicketingAndRecommendationSystem\CineFlowAPI
.\.venv\Scripts\python.exe -m uvicorn app.main:app --reload
```

看到下面信息说明启动成功：

```text
Uvicorn running on http://127.0.0.1:8000
```

默认 SQLite 会初始化演示数据和账号：

| 角色 | 用户名 | 密码 |
|---|---|---|
| 普通用户 | `test_user` | `Test1234` |
| 管理员 | `admin` | `Admin123` |

如果后端连接 MySQL，请确保数据库已经建表，并且至少存在可用电影、未来场次和可用座位。

### 2.2 导入 OpenAPI Collection

你已经完成导入时，可以直接跳到 2.3。

第一次导入按以下步骤操作：

1. 先启动 `CineFlowAPI`。
2. 在浏览器打开 `http://127.0.0.1:8000/openapi.json`，确认能看到 JSON。
3. 回到 Postman，点击左上角 **Import**。
4. 选择 **Link**，粘贴 OpenAPI 地址；如果 Link 不能访问 localhost，就在浏览器将 JSON 保存为本地文件，然后选择 **Files**。
5. 出现导入方式时，选择包含 **Postman Collection** 的选项，不要只导入 Specification。
6. 点击 **Import**。
7. 回到左侧 **Collections**。
8. 找到 `CineFlowAPI - 影流电影票务与推荐系统`。
9. 展开后应看到 `api` 和 `health`。
10. 展开 `api` 后应看到 `auth、movies、cinemas、schedules、orders、reviews、recommendations、stat、admin`。

如果导入结果只出现在左侧 **SPECS**：

1. 展开 **SPECS**。
2. 打开 CineFlowAPI 规范。
3. 点击 **Generate collection** 或 **Create collection**。
4. 保存到当前 Workspace。

不要把自动生成的请求再次复制到手工 Collection，直接使用导入生成的 Collection 最简单。

### 2.3 创建 Environment

1. 点击右上角 **Environments**。
2. 新建环境：`CineFlow Local`。
3. 添加下列变量。

| 变量 | Initial value / Current value | 用途 |
|---|---|---|
| `base_url` | `http://127.0.0.1:8000` | 后端基础地址 |
| `baseUrl` | `http://127.0.0.1:8000` | 兼容 OpenAPI 自动生成的 URL |
| `user_username` | `test_user` | 普通用户 |
| `user_password` | `Test1234` | 普通用户密码 |
| `admin_username` | `admin` | 管理员 |
| `admin_password` | `Admin123` | 管理员密码 |
| `user_token` | 空 | 普通用户 Token |
| `admin_token` | 空 | 管理员 Token |
| `user_id` | 空 | 当前普通用户 ID |
| `movie_id` | 空 | 当前电影 ID |
| `cinema_id` | 空 | 当前影院 ID |
| `schedule_id` | 空 | 当前场次 ID |
| `seat_id` | 空 | 当前座位 ID |
| `second_seat_id` | 空 | 取消/支付失败分支使用的座位 |
| `order_id` | 空 | 当前订单 ID |
| `order_no` | 空 | 当前订单号 |
| `idempotency_key` | 空 | 下单幂等键 |
| `trade_no` | 空 | 支付流水号 |
| `review_id` | 空 | 评论 ID |
| `created_movie_id` | 空 | 管理员新建电影 ID |
| `created_cinema_id` | 空 | 管理员新建影院 ID |
| `created_schedule_id` | 空 | 管理员新建场次 ID |
| `registered_username` | 空 | 动态注册用户 |
| `registered_password` | `Postman123` | 动态注册用户密码 |

选择 `CineFlow Local` 作为当前环境。

根据你当前截图，还需要立即检查两点：

1. 你填写的是 `schdule_id`，少了一个字母 `e`。必须改成准确的 `schedule_id`，否则后续场次和座位 URL 会显示变量未定义。
2. 补充 `baseUrl` 变量并填写 `http://127.0.0.1:8000`，因为 OpenAPI 自动生成的请求很可能使用这个名称。

环境变量名称必须完全一致，包括大小写和下划线。修改完成后按 `Ctrl + S`，并确认 Postman 右上角当前选中的环境仍是 `CineFlow Local`。

### 2.4 Collection 公共测试脚本

按下面步骤设置：

1. 在左侧点击最上层 Collection 名称 `CineFlowAPI - 影流电影票务与推荐系统`，不要点击具体请求。
2. 中间会出现 `Overview、Authorization、Scripts、Variables、Runs`。
3. 点击 **Scripts**。
4. 左侧脚本类型中点击 **After response**。它就是其他版本所说的 Post-response。
5. 将下面代码粘贴到右侧编辑器。
6. 按 `Ctrl + S` 保存。

公共脚本：

```javascript
pm.test("响应时间小于 3000ms", function () {
    pm.expect(pm.response.responseTime).to.be.below(3000);
});

if (pm.response.code !== 204 && pm.response.text()) {
    pm.test("响应 Content-Type 为 JSON", function () {
        pm.expect(pm.response.headers.get("Content-Type")).to.include("application/json");
    });
}
```

不要在 Collection 层强制断言所有响应都是 200，因为项目中还存在 201、204、400、401、403、404、409 和 422。

保存后 `Scripts` 标签旁边通常会出现绿色圆点，表示存在尚未保存或已经配置的脚本；按 `Ctrl + S` 后再切换页面确认代码仍然存在。

## 三、通用请求设置

### 3.0 先设置 Collection 为 No Auth

1. 左侧点击最上层 Collection 名称。
2. 点击中间顶部 **Authorization**。
3. 如果页面显示 `No auth configured`，保持现状即可。
4. 不要在整个 Collection 上配置普通用户 Token，因为健康检查和登录本身不需要登录。

然后按文件夹设置鉴权，可以减少逐个请求填写 Token：

| 文件夹 | 建议 Authorization | 原因 |
|---|---|---|
| `auth` | No Auth / Inherit | 注册登录是公开接口 |
| `movies` | No Auth / Inherit | 电影查询是公开接口 |
| `cinemas` | No Auth / Inherit | 影院查询是公开接口 |
| `schedules` | Bearer `{{user_token}}` | 锁座需要登录；查询座位带 Token 也不影响 |
| `orders` | Bearer `{{user_token}}` | 订单接口全部需要普通用户登录 |
| `reviews` | Bearer `{{user_token}}` | 保存和删除评论需要登录；查询时带 Token 也不影响 |
| `recommendations` | Bearer `{{user_token}}` | 个性化推荐需要登录；热门推荐带 Token 也不影响 |
| `stat` | No Auth / Inherit | 统计接口公开 |
| `admin` | Bearer `{{admin_token}}` | 管理员接口需要 ADMIN Token |
| `health` | No Auth / Inherit | 系统健康检查公开 |

文件夹级别设置方法：

1. 左侧点击文件夹名称，例如 `orders`，不要点里面的具体请求。
2. 中间点击 **Authorization**。
3. 选择 **Bearer Token**。
4. Token 输入 `{{user_token}}`。
5. 按 `Ctrl + S` 保存。
6. 以后打开该文件夹中的请求，Authorization 选择 **Inherit auth from parent** 即可。

管理员文件夹执行同样操作，但 Token 必须填写 `{{admin_token}}`。

### 3.1 无需登录的请求

操作方法：

1. 打开具体请求。
2. 点击 URL 下方的 **Authorization**。
3. Auth Type 选择 **No Auth**，或者选择 **Inherit auth from parent** 并确保上层文件夹是 No Auth。
4. 按 `Ctrl + S`。

### 3.2 普通用户请求

操作方法：

1. 打开具体请求。
2. 点击 **Authorization**。
3. Auth Type 选择 **Bearer Token**。
4. 在 Token 输入框填写：

```text
{{user_token}}
```

5. 鼠标移到 `{{user_token}}` 上，确认弹窗能显示一个很长的 JWT 值。
6. 如果显示红色或空值，先执行普通用户登录请求。
7. 按 `Ctrl + S`。

### 3.3 管理员请求

操作方法：

1. 打开具体管理员请求。
2. 点击 **Authorization**。
3. Auth Type 选择 **Bearer Token**。
4. Token 填：

```text
{{admin_token}}
```

5. 如果变量为空，先执行管理员登录。
6. 按 `Ctrl + S`。

### 3.4 JSON 请求头

POST、PUT 请求按以下方式填写 JSON：

1. 打开请求。
2. 点击 URL 下方的 **Body**。
3. 选择 **raw**。
4. 在编辑器右侧的格式下拉框选择 **JSON**，不要选择 Text。
5. 删除 OpenAPI 自动生成的示例占位值。
6. 粘贴本文给出的 JSON Body。
7. 点击 **Headers**，确认 Postman 已自动添加：

```text
Content-Type: application/json
```

8. 按 `Ctrl + S` 保存后再 Send。

如果 JSON 左侧出现红色标记，通常是漏写逗号、双引号或大括号。`{{seat_id}}` 等数值变量在 JSON 中不加引号，Token、用户名和幂等键等字符串需要放在双引号内。

### 3.5 通用成功响应结构

除 204 删除接口外，成功响应结构为：

```json
{
  "code": 0,
  "message": "success",
  "data": {},
  "timestamp": 1700000000000
}
```

可在单个请求的 Post-response 中复用：

```javascript
const body = pm.response.json();

pm.test("业务码为 0", function () {
    pm.expect(body.code).to.eql(0);
});

pm.test("统一响应字段完整", function () {
    pm.expect(body).to.have.all.keys("code", "message", "data", "timestamp");
    pm.expect(body.message).to.eql("success");
    pm.expect(body.timestamp).to.be.a("number");
});
```

## 四、00-系统检查

### 4.1 健康检查

这是你导入 OpenAPI 后应该执行的第一个请求。

详细操作：

1. 在左侧 Collection 中展开 `health` 文件夹。
2. 点击绿色的 `GET Health` 请求，不要点击手工创建但无法加载的旧请求。
3. 中间顶部应出现绿色方法 `GET`、URL 地址栏和 `Send` 按钮。
4. 如果 URL 是 `{{baseUrl}}/health`，可以保持不变，但必须确认环境里已经添加 `baseUrl`。
5. 如果 URL 变量显示红色，直接改成 `{{base_url}}/health`。
6. 点击 **Authorization**，选择 **No Auth** 或 **Inherit auth from parent**。
7. 点击 **Scripts → After response**，粘贴本节断言脚本。
8. 按 `Ctrl + S` 保存。
9. 点击右上方 **Send**。
10. 查看响应区域左上方是否为 `200 OK`。
11. 点击响应区域的 **Body**，确认 `data.status` 是 `UP`。
12. 点击响应区域的 **Test Results**，确认“健康检查成功”和 Collection 公共断言均为 PASS。

请求：

```http
GET {{base_url}}/health
```

Authorization：`No Auth`

Post-response：

```javascript
pm.test("健康检查成功", function () {
    pm.response.to.have.status(200);
    const body = pm.response.json();
    pm.expect(body.code).to.eql(0);
    pm.expect(body.data.status).to.eql("UP");
});
```

如果此步骤失败，不要继续执行后续请求，应先检查后端进程、端口和数据库连接。

## 五、01-用户与鉴权

### 5.1 动态注册用户

请求：

```http
POST {{base_url}}/api/auth/register
```

Pre-request：

```javascript
const suffix = Date.now().toString();
const username = "postman_" + suffix;
const phone = "18" + suffix.slice(-9);

pm.environment.set("registered_username", username);
pm.environment.set("registered_phone", phone);
pm.environment.set("registered_email", username + "@example.com");
```

Body：

```json
{
  "username": "{{registered_username}}",
  "phone": "{{registered_phone}}",
  "email": "{{registered_email}}",
  "password": "{{registered_password}}"
}
```

Post-response：

```javascript
pm.test("注册返回 201", function () {
    pm.response.to.have.status(201);
});

const body = pm.response.json();
pm.test("注册业务成功", function () {
    pm.expect(body.code).to.eql(0);
    pm.expect(body.data.id).to.be.a("number");
    pm.expect(body.data.username).to.eql(pm.environment.get("registered_username"));
});
```

### 5.2 重复用户名注册

直接再次发送 5.1 的同一个请求，不重新运行生成新用户名的脚本。最简单的做法是复制 5.1 请求，删除复制请求中的 Pre-request。

预期：

```text
HTTP 409
code = 409
message 包含“用户名已被注册”
```

Post-response：

```javascript
pm.test("重复用户名被拒绝", function () {
    pm.response.to.have.status(409);
    const body = pm.response.json();
    pm.expect(body.code).to.eql(409);
    pm.expect(body.message).to.include("已被注册");
});
```

### 5.3 动态用户登录

请求：

```http
POST {{base_url}}/api/auth/login
```

Body：

```json
{
  "username": "{{registered_username}}",
  "password": "{{registered_password}}"
}
```

预期 HTTP 200，并返回 `token`、`tokenType`、`expiresIn` 和 `user`。

### 5.4 普通演示用户登录并保存 Token

请求：

```http
POST {{base_url}}/api/auth/login
```

Body：

```json
{
  "username": "{{user_username}}",
  "password": "{{user_password}}"
}
```

Post-response：

```javascript
pm.test("普通用户登录成功", function () {
    pm.response.to.have.status(200);
});

const body = pm.response.json();
pm.test("Token 字段有效", function () {
    pm.expect(body.code).to.eql(0);
    pm.expect(body.data.token).to.be.a("string").and.not.empty;
    pm.expect(body.data.tokenType).to.eql("Bearer");
    pm.expect(body.data.user.role).to.eql("USER");
});

pm.environment.set("user_token", body.data.token);
pm.environment.set("user_id", body.data.user.id);
```

### 5.5 管理员登录并保存 Token

请求与 5.4 相同，Body 改为：

```json
{
  "username": "{{admin_username}}",
  "password": "{{admin_password}}"
}
```

Post-response：

```javascript
const body = pm.response.json();

pm.test("管理员登录成功", function () {
    pm.response.to.have.status(200);
    pm.expect(body.code).to.eql(0);
    pm.expect(body.data.user.role).to.eql("ADMIN");
});

pm.environment.set("admin_token", body.data.token);
```

### 5.6 密码错误

Body：

```json
{
  "username": "{{user_username}}",
  "password": "WrongPassword123"
}
```

预期：HTTP 401、`code = 401`、`message = 用户名或密码错误`。

## 六、02-电影、影院与场次

### 6.1 查询电影列表并保存电影 ID

请求：

```http
GET {{base_url}}/api/movies?pageNum=1&pageSize=10
```

Post-response：

```javascript
const body = pm.response.json();

pm.test("电影列表查询成功", function () {
    pm.response.to.have.status(200);
    pm.expect(body.code).to.eql(0);
    pm.expect(body.data.list).to.be.an("array").that.is.not.empty;
    pm.expect(body.data.pageNum).to.eql(1);
    pm.expect(body.data.pageSize).to.eql(10);
    pm.expect(body.data.list.length).to.be.at.most(10);
});

const movie = body.data.list.find(item =>
    item.status === "AVAILABLE" &&
    item.genres && item.genres.includes("科幻") &&
    item.regions && item.regions.includes("中国大陆")
);

pm.test("存在用于购票测试的中国大陆科幻电影", function () {
    pm.expect(movie).to.exist;
});

if (movie) {
    pm.environment.set("movie_id", movie.id);
}
```

### 6.2 多条件筛选电影

请求参数：

```http
GET {{base_url}}/api/movies?genre=科幻&region=中国大陆&pageNum=1&pageSize=10
```

Post-response：

```javascript
const list = pm.response.json().data.list;

pm.test("筛选结果全部符合条件", function () {
    list.forEach(item => {
        pm.expect(item.genres).to.include("科幻");
        pm.expect(item.regions).to.include("中国大陆");
        pm.expect(item.status).to.eql("AVAILABLE");
    });
});
```

其他可分别测试的 Query 参数：

| 参数 | 示例 | 约束 |
|---|---|---|
| `genre` | `科幻` | 类型包含匹配 |
| `region` | `中国大陆` | 地区包含匹配 |
| `year` | `2019` | 上映年份 |
| `minScore` | `8` | 0～10 |
| `pageNum` | `1` | 必须大于等于 1 |
| `pageSize` | `10` | 1～100 |

### 6.3 查询电影详情

```http
GET {{base_url}}/api/movies/{{movie_id}}
```

Post-response：

```javascript
const body = pm.response.json();
pm.test("电影详情 ID 正确", function () {
    pm.response.to.have.status(200);
    pm.expect(body.code).to.eql(0);
    pm.expect(body.data.id).to.eql(Number(pm.environment.get("movie_id")));
    pm.expect(body.data).to.have.property("name");
    pm.expect(body.data).to.have.property("genres");
    pm.expect(body.data).to.have.property("regions");
    pm.expect(body.data).to.have.property("score");
});
```

### 6.4 查询热门电影

```http
GET {{base_url}}/api/movies/hot?limit=10
```

Post-response：

```javascript
const list = pm.response.json().data;
const ids = list.map(item => item.id);

pm.test("热门电影不重复且不包含下架电影", function () {
    pm.expect(new Set(ids).size).to.eql(ids.length);
    list.forEach(item => pm.expect(item.status).to.eql("AVAILABLE"));
});
```

注意：`/api/movies/hot` 必须放在 `/api/movies/{{movie_id}}` 之前或独立保存，避免把 `hot` 误当成电影 ID 的调试混淆。

### 6.5 查询影院并保存影院 ID

```http
GET {{base_url}}/api/cinemas
```

Post-response：

```javascript
const body = pm.response.json();
pm.test("影院列表不为空", function () {
    pm.response.to.have.status(200);
    pm.expect(body.data).to.be.an("array").that.is.not.empty;
});
pm.environment.set("cinema_id", body.data[0].id);
```

### 6.6 查询电影未来场次并保存场次 ID

```http
GET {{base_url}}/api/movies/{{movie_id}}/schedules
```

Post-response：

```javascript
const body = pm.response.json();
const schedule = body.data.find(item => item.status === "ON_SALE");

pm.test("存在可售场次", function () {
    pm.response.to.have.status(200);
    pm.expect(schedule).to.exist;
});

if (schedule) {
    pm.environment.set("schedule_id", schedule.id);
    pm.environment.set("cinema_id", schedule.cinemaId);
}
```

如果返回空数组，通常是场次已经过期。可以执行本文管理员创建场次步骤，或重新初始化演示数据库。

### 6.7 查询座位并保存两个可用座位

```http
GET {{base_url}}/api/schedules/{{schedule_id}}/seats
```

Post-response：

```javascript
const body = pm.response.json();
const available = body.data.filter(item => item.status === "AVAILABLE");

pm.test("至少有两个可用座位", function () {
    pm.response.to.have.status(200);
    pm.expect(available.length).to.be.at.least(2);
});

if (available.length >= 2) {
    pm.environment.set("seat_id", available[0].id);
    pm.environment.set("second_seat_id", available[1].id);
}
```

## 七、03-购票订单主链路

本文件夹请求均使用：

```text
Bearer Token: {{user_token}}
```

### 7.1 锁定座位

```http
POST {{base_url}}/api/schedules/{{schedule_id}}/seats/lock
```

Body：

```json
{
  "seatIds": [{{seat_id}}]
}
```

Post-response：

```javascript
const body = pm.response.json();
pm.test("座位锁定成功", function () {
    pm.response.to.have.status(200);
    pm.expect(body.code).to.eql(0);
    pm.expect(body.data.scheduleId).to.eql(Number(pm.environment.get("schedule_id")));
    pm.expect(body.data.seats[0].status).to.eql("LOCKED");
    pm.expect(body.data.expiresAt).to.be.a("string");
});
```

### 7.2 创建幂等订单并保存订单 ID

```http
POST {{base_url}}/api/orders
```

Pre-request：

```javascript
pm.environment.set("idempotency_key", "postman-order-" + Date.now());
```

Body：

```json
{
  "scheduleId": {{schedule_id}},
  "seatIds": [{{seat_id}}],
  "idempotencyKey": "{{idempotency_key}}"
}
```

Post-response：

```javascript
const body = pm.response.json();

pm.test("订单创建成功", function () {
    pm.response.to.have.status(201);
    pm.expect(body.code).to.eql(0);
    pm.expect(body.data.status).to.eql("PENDING_PAYMENT");
    pm.expect(body.data.scheduleId).to.eql(Number(pm.environment.get("schedule_id")));
    pm.expect(body.data.seats).to.have.lengthOf(1);
    pm.expect(body.data.totalAmount).to.be.above(0);
});

pm.environment.set("order_id", body.data.id);
pm.environment.set("order_no", body.data.orderNo);
pm.environment.set("first_order_id", body.data.id);
```

### 7.3 使用相同幂等键重复下单

复制 7.2 请求，必须删除复制请求中的 Pre-request，否则会生成新的幂等键。Body 保持不变。

Post-response：

```javascript
const body = pm.response.json();
pm.test("相同幂等键返回同一订单", function () {
    pm.response.to.have.status(201);
    pm.expect(body.data.id).to.eql(Number(pm.environment.get("first_order_id")));
    pm.expect(body.data.orderNo).to.eql(pm.environment.get("order_no"));
});
```

数据库中不应新增第二个订单。

### 7.4 查询我的订单列表

```http
GET {{base_url}}/api/orders
```

Post-response：

```javascript
const list = pm.response.json().data;
const target = list.find(item => item.id === Number(pm.environment.get("order_id")));

pm.test("订单列表包含刚创建的订单", function () {
    pm.response.to.have.status(200);
    pm.expect(target).to.exist;
});
```

### 7.5 查询订单详情

```http
GET {{base_url}}/api/orders/{{order_id}}
```

Post-response：

```javascript
const order = pm.response.json().data;
pm.test("订单详情正确", function () {
    pm.response.to.have.status(200);
    pm.expect(order.id).to.eql(Number(pm.environment.get("order_id")));
    pm.expect(order.orderNo).to.eql(pm.environment.get("order_no"));
    pm.expect(order.status).to.eql("PENDING_PAYMENT");
});
```

### 7.6 支付成功

```http
POST {{base_url}}/api/orders/{{order_id}}/payment-callback
```

Pre-request：

```javascript
pm.environment.set("trade_no", "postman-pay-" + Date.now());
```

Body：

```json
{
  "providerTradeNo": "{{trade_no}}",
  "success": true
}
```

Post-response：

```javascript
const body = pm.response.json();
pm.test("支付后订单变为 PAID", function () {
    pm.response.to.have.status(200);
    pm.expect(body.code).to.eql(0);
    pm.expect(body.data.status).to.eql("PAID");
    pm.expect(body.data.paidAt).to.be.a("string");
    pm.expect(body.data.seats[0].status).to.eql("SOLD");
});
```

### 7.7 重复支付回调

复制 7.6 请求，删除 Pre-request，继续使用相同的 `{{trade_no}}`。

预期仍返回 HTTP 200、同一个订单，数据库中只有一条对应的支付事件。

```javascript
pm.test("重复支付回调保持幂等", function () {
    pm.response.to.have.status(200);
    const body = pm.response.json();
    pm.expect(body.data.id).to.eql(Number(pm.environment.get("order_id")));
    pm.expect(body.data.status).to.eql("PAID");
});
```

支付完成后先执行“评分评论与推荐”，最后再执行退款。

## 八、04-订单异常与分支

这些分支会改变座位和订单状态。每个分支开始前建议重新执行 6.7，选择新的 `AVAILABLE` 座位并生成新的幂等键。

### 8.1 已售座位再次下单

使用 7.6 已经支付成功的 `{{seat_id}}`，但换一个幂等键：

```json
{
  "scheduleId": {{schedule_id}},
  "seatIds": [{{seat_id}}],
  "idempotencyKey": "sold-seat-{{$timestamp}}"
}
```

预期：HTTP 409，消息包含 `座位已售`。

### 8.2 重复座位 ID

```json
{
  "scheduleId": {{schedule_id}},
  "seatIds": [{{second_seat_id}}, {{second_seat_id}}],
  "idempotencyKey": "duplicate-seat-{{$timestamp}}"
}
```

预期：HTTP 422，原因是 `seatIds` 不允许重复。

### 8.3 座位不属于场次或不存在

```json
{
  "scheduleId": {{schedule_id}},
  "seatIds": [999999999],
  "idempotencyKey": "missing-seat-{{$timestamp}}"
}
```

预期：HTTP 404，消息包含 `座位不存在或不属于该场次`。

### 8.4 一次选择超过 8 个座位

```json
{
  "scheduleId": {{schedule_id}},
  "seatIds": [1, 2, 3, 4, 5, 6, 7, 8, 9],
  "idempotencyKey": "too-many-seats-{{$timestamp}}"
}
```

预期：HTTP 422。此用例主要验证请求参数上限，座位是否真实存在不是本用例重点。

### 8.5 创建待取消订单

先重新查询座位，将一个新可用座位保存为 `second_seat_id`，然后请求：

```http
POST {{base_url}}/api/orders
```

```json
{
  "scheduleId": {{schedule_id}},
  "seatIds": [{{second_seat_id}}],
  "idempotencyKey": "cancel-order-{{$timestamp}}"
}
```

在 Post-response 中保存：

```javascript
const body = pm.response.json();
pm.environment.set("cancel_order_id", body.data.id);
pm.environment.set("cancel_seat_id", body.data.seats[0].id);
```

### 8.6 取消待支付订单

```http
POST {{base_url}}/api/orders/{{cancel_order_id}}/cancel
```

预期：HTTP 200、订单状态 `CANCELLED`，座位状态 `AVAILABLE`。

```javascript
const order = pm.response.json().data;
pm.test("取消订单并释放座位", function () {
    pm.expect(order.status).to.eql("CANCELLED");
    pm.expect(order.seats[0].status).to.eql("AVAILABLE");
});
```

### 8.7 重复取消订单

再次执行 8.6。

预期：HTTP 409，消息为 `只有待支付订单可以取消`。

### 8.8 支付失败分支

重新创建一个待支付订单并将 ID 保存为 `failed_order_id`，然后请求：

```http
POST {{base_url}}/api/orders/{{failed_order_id}}/payment-callback
```

```json
{
  "providerTradeNo": "failed-pay-{{$timestamp}}",
  "success": false
}
```

预期：订单状态 `PAYMENT_FAILED`，座位恢复 `AVAILABLE`。

### 8.9 待支付订单直接退款

对新的 `PENDING_PAYMENT` 订单执行：

```http
POST {{base_url}}/api/orders/{{order_id}}/refund
```

预期：HTTP 409，消息为 `只有已支付订单可以退款`。

## 九、05-评分评论与推荐

先保证 7.6 的订单已经支付成功，当前用户才有资格对对应电影评分。

### 9.1 已购票用户新增或更新评论

```http
PUT {{base_url}}/api/movies/{{movie_id}}/reviews
```

Authorization：`Bearer {{user_token}}`

Body：

```json
{
  "rating": 9.0,
  "content": "Postman 完整购票链路测试评论"
}
```

Post-response：

```javascript
const body = pm.response.json();
pm.test("评分评论保存成功", function () {
    pm.response.to.have.status(200);
    pm.expect(body.data.movieId).to.eql(Number(pm.environment.get("movie_id")));
    pm.expect(body.data.rating).to.eql(9);
    pm.expect(body.data.content).to.include("Postman");
});
pm.environment.set("review_id", body.data.id);
```

同一用户对同一电影再次 PUT 会更新原评论，而不是新建第二条。

### 9.2 查询电影评论

```http
GET {{base_url}}/api/movies/{{movie_id}}/reviews?pageNum=1&pageSize=10
```

Post-response：

```javascript
const data = pm.response.json().data;
const target = data.list.find(item => item.id === Number(pm.environment.get("review_id")));
pm.test("评论列表包含当前评论", function () {
    pm.response.to.have.status(200);
    pm.expect(target).to.exist;
});
```

### 9.3 评分越界

Body：

```json
{
  "rating": 11,
  "content": "越界评分"
}
```

预期：HTTP 422、`code = 422`。

再测试 `rating = 0`，同样应返回 422。有效边界是 1 和 10。

### 9.4 评论为空白

```json
{
  "rating": 8,
  "content": "   "
}
```

预期：HTTP 422，消息包含 `评论内容不能为空`。

### 9.5 热门推荐

```http
GET {{base_url}}/api/recommendations/hot?limit=10
```

Authorization：`No Auth`

Post-response：

```javascript
const list = pm.response.json().data;
const ids = list.map(item => item.id);
pm.test("热门推荐结果合法", function () {
    pm.response.to.have.status(200);
    pm.expect(list.length).to.be.at.most(10);
    pm.expect(new Set(ids).size).to.eql(ids.length);
    list.forEach(item => pm.expect(item.status).to.eql("AVAILABLE"));
});
```

### 9.6 个性化推荐

```http
GET {{base_url}}/api/recommendations/me?limit=10
```

Authorization：`Bearer {{user_token}}`

规则断言：数量不超过 limit、ID 不重复、没有 `OFF_SHELF`。不要断言固定电影 ID，因为推荐结果会随用户评分和热度变化。

### 9.7 删除自己的评论（可选清理）

```http
DELETE {{base_url}}/api/reviews/{{review_id}}
```

预期 HTTP 204，没有 JSON 响应体。

```javascript
pm.test("评论删除成功", function () {
    pm.response.to.have.status(204);
    pm.expect(pm.response.text()).to.eql("");
});
```

### 9.8 退款已支付订单

```http
POST {{base_url}}/api/orders/{{order_id}}/refund
```

Authorization：`Bearer {{user_token}}`

Post-response：

```javascript
const order = pm.response.json().data;
pm.test("退款成功并释放座位", function () {
    pm.response.to.have.status(200);
    pm.expect(order.status).to.eql("REFUNDED");
    pm.expect(order.refundedAt).to.be.a("string");
    pm.expect(order.seats[0].status).to.eql("AVAILABLE");
});
```

### 9.9 重复退款

再次执行 9.8。

预期：HTTP 409，消息为 `只有已支付订单可以退款`。

## 十、06-统计分析

统计接口均不需要 Token，成功时应满足：HTTP 200、`code = 0`、`data` 不为 `null`。

| 序号 | 方法与 URL | 主要返回字段 |
|---|---|---|
| 1 | `GET {{base_url}}/api/stat/actor-top50` | `personName`、`actedMovieCnt` |
| 2 | `GET {{base_url}}/api/stat/high-score-average` | `threshold`、`averageScore` |
| 3 | `GET {{base_url}}/api/stat/mins-summary` | `totalMins`、`averageMins`、`minMins`、`maxMins` |
| 4 | `GET {{base_url}}/api/stat/year-top20?year=2019` | `movieYear`、`movieId`、`doubanScore` |
| 5 | `GET {{base_url}}/api/stat/region-year-average-score?region=中国大陆&year=2019` | `regionName`、`movieYear`、`regionScoreAvg` |
| 6 | `GET {{base_url}}/api/stat/year-region-count?year=2019&region=中国大陆` | `movieYear`、`regionName`、`regionYearCount` |

列表统计接口可以使用以下通用 Post-response。注意：`high-score-average` 和 `mins-summary` 返回的是对象，不是数组，不能直接套这个断言。

```javascript
const body = pm.response.json();
pm.test("统计接口响应成功", function () {
    pm.response.to.have.status(200);
    pm.expect(body.code).to.eql(0);
    pm.expect(body.data).to.be.an("array");
});
```

注意：数组为空不等于接口失败。若 `stat_actor_top50`、`stat_region_year_avg_score`、`stat_year_region_count` 或 `stat_year_top20_movie` 没有成功导入数据，对应接口会返回空数组。此时需要检查数据库导入，而不是修改 Postman 预期为接口错误。

地区年份筛选断言示例：

```javascript
const list = pm.response.json().data;
pm.test("地区年份筛选正确", function () {
    list.forEach(item => {
        pm.expect(item.regionName).to.eql("中国大陆");
        pm.expect(item.movieYear).to.eql(2019);
        pm.expect(item.regionScoreAvg).to.be.at.least(0);
    });
});
```

## 十一、07-管理员接口

所有请求使用：

```text
Bearer Token: {{admin_token}}
```

### 11.1 管理员权限检查

```http
GET {{base_url}}/api/admin/health
```

预期 HTTP 200、`data.status = UP`。

### 11.2 创建电影

```http
POST {{base_url}}/api/admin/movies
```

Body：

```json
{
  "name": "Postman 测试电影 {{$timestamp}}",
  "genres": "科幻/剧情",
  "regions": "中国大陆",
  "releaseYear": 2026,
  "score": 8.6,
  "status": "AVAILABLE"
}
```

Post-response：

```javascript
const body = pm.response.json();
pm.test("管理员创建电影成功", function () {
    pm.response.to.have.status(201);
    pm.expect(body.data.id).to.be.a("number");
    pm.expect(body.data.status).to.eql("AVAILABLE");
});
pm.environment.set("created_movie_id", body.data.id);
```

### 11.3 创建影院

```http
POST {{base_url}}/api/admin/cinemas
```

Body：

```json
{
  "name": "Postman 测试影城 {{$timestamp}}",
  "address": "北京市测试路 100 号",
  "city": "北京"
}
```

Post-response：

```javascript
const body = pm.response.json();
pm.test("管理员创建影院成功", function () {
    pm.response.to.have.status(201);
    pm.expect(body.data.id).to.be.a("number");
});
pm.environment.set("created_cinema_id", body.data.id);
```

### 11.4 创建未来场次并自动生成座位

```http
POST {{base_url}}/api/admin/schedules
```

Pre-request：

```javascript
const start = new Date(Date.now() + 24 * 60 * 60 * 1000);
const end = new Date(start.getTime() + 120 * 60 * 1000);
pm.environment.set("future_start", start.toISOString());
pm.environment.set("future_end", end.toISOString());
```

Body：

```json
{
  "movieId": {{created_movie_id}},
  "cinemaId": {{created_cinema_id}},
  "hallName": "Postman 1号厅",
  "startTime": "{{future_start}}",
  "endTime": "{{future_end}}",
  "price": 49.90,
  "rows": 3,
  "seatsPerRow": 6
}
```

Post-response：

```javascript
const body = pm.response.json();
pm.test("创建场次成功", function () {
    pm.response.to.have.status(201);
    pm.expect(body.data.movieId).to.eql(Number(pm.environment.get("created_movie_id")));
    pm.expect(body.data.cinemaId).to.eql(Number(pm.environment.get("created_cinema_id")));
    pm.expect(body.data.status).to.eql("ON_SALE");
});
pm.environment.set("created_schedule_id", body.data.id);
```

然后执行：

```http
GET {{base_url}}/api/schedules/{{created_schedule_id}}/seats
```

断言应生成 `3 × 6 = 18` 个座位：

```javascript
pm.test("场次自动生成 18 个座位", function () {
    const seats = pm.response.json().data;
    pm.expect(seats).to.have.lengthOf(18);
    seats.forEach(item => pm.expect(item.status).to.eql("AVAILABLE"));
});
```

### 11.5 结束时间早于开始时间

交换 `startTime` 和 `endTime`。

预期：HTTP 400，消息为 `endTime 必须晚于 startTime`。

### 11.6 电影或影院不存在

将 `movieId` 或 `cinemaId` 改为 `999999999`。

预期：HTTP 404，消息为 `电影或影院不存在`。

## 十二、08-权限与边界异常

### 12.1 缺少 Token 查询订单

```http
GET {{base_url}}/api/orders
```

Authorization：`No Auth`

预期：HTTP 401，消息为 `缺少 token`。

### 12.2 伪造 Token

Authorization → Bearer Token：

```text
not-a-valid-jwt
```

请求 `/api/orders`，预期 HTTP 401，消息为 `token 格式无效`。

### 12.3 修改合法 Token 的最后一个字符

复制 `{{user_token}}` 的值并修改最后一个字符，请求 `/api/orders`。

预期 HTTP 401，消息为 `token 伪造或签名无效`。

### 12.4 普通用户访问管理员接口

```http
GET {{base_url}}/api/admin/health
```

Authorization：`Bearer {{user_token}}`

预期：HTTP 403，消息为 `普通用户无权访问管理员接口`。

### 12.5 查询不存在电影

```http
GET {{base_url}}/api/movies/999999999
```

预期：HTTP 404、`code = 404`、消息为 `电影不存在`。

### 12.6 非法分页

分别执行：

```http
GET {{base_url}}/api/movies?pageNum=0
GET {{base_url}}/api/movies?pageSize=0
GET {{base_url}}/api/movies?pageSize=101
```

预期 HTTP 400。

### 12.7 热门电影 limit 边界

```http
GET {{base_url}}/api/movies/hot?limit=0
GET {{base_url}}/api/movies/hot?limit=101
```

预期 HTTP 400。有效范围为 1～100。

### 12.8 推荐 limit 边界

```http
GET {{base_url}}/api/recommendations/hot?limit=0
GET {{base_url}}/api/recommendations/hot?limit=51
```

预期 HTTP 400。有效范围为 1～50。

### 12.9 注册字段边界

| 场景 | 示例 | 预期 |
|---|---|---|
| 用户名少于 3 位 | `ab` | 422 |
| 用户名包含中文或符号 | `测试用户!` | 422 |
| 手机号格式错误 | `12345` | 422 |
| 邮箱格式错误 | `abc` | 422 |
| 密码少于 6 位 | `A123` | 422 |
| 密码只有字母 | `abcdef` | 422 |
| 密码只有数字 | `123456` | 422 |
| 合法密码 | `Test1234` | 201 或重复数据 409 |

## 十三、数据库一致性验证

Postman 验证接口响应，DataGrip 验证数据库最终状态。不要在生产数据库执行这些测试。

### 13.1 验证幂等订单

```sql
SELECT id, order_no, user_id, schedule_id, status, idempotency_key,
       total_amount, paid_at, refunded_at
FROM ticket_order
WHERE id = 你的order_id;
```

验证同一幂等键只有一个订单：

```sql
SELECT COUNT(*) AS order_count
FROM ticket_order
WHERE user_id = 你的user_id
  AND idempotency_key = '你的idempotency_key';
```

预期：`order_count = 1`。

### 13.2 验证订单座位关系

```sql
SELECT os.order_id, os.seat_id, os.price,
       ss.status, ss.lock_user_id, ss.lock_expires_at, ss.order_id AS seat_order_id
FROM order_seat os
JOIN schedule_seat ss ON ss.id = os.seat_id
WHERE os.order_id = 你的order_id;
```

状态预期：

| 阶段 | 订单状态 | 座位状态 |
|---|---|---|
| 下单后 | `PENDING_PAYMENT` | `LOCKED` |
| 支付后 | `PAID` | `SOLD` |
| 取消后 | `CANCELLED` | `AVAILABLE` |
| 支付失败后 | `PAYMENT_FAILED` | `AVAILABLE` |
| 退款后 | `REFUNDED` | `AVAILABLE` |

### 13.3 验证支付幂等

```sql
SELECT COUNT(*) AS payment_event_count
FROM payment_event
WHERE provider_trade_no = '你的trade_no';
```

重复发送相同支付流水号后，预期仍为 `1`。

### 13.4 验证评论唯一性

```sql
SELECT id, user_id, movie_id, rating, content, created_at, updated_at
FROM movie_review
WHERE user_id = 你的user_id
  AND movie_id = 你的movie_id;
```

同一用户多次 PUT 同一电影时应更新原记录，最多只有一条。

### 13.5 验证管理员创建座位数量

```sql
SELECT schedule_id, COUNT(*) AS seat_count
FROM schedule_seat
WHERE schedule_id = 你的created_schedule_id
GROUP BY schedule_id;
```

使用 `rows = 3`、`seatsPerRow = 6` 时预期为 18。

## 十四、Collection Runner 执行顺序

第一次完整执行建议按以下顺序：

```text
1. 健康检查
2. 动态注册用户
3. 重复用户名注册
4. 普通演示用户登录
5. 管理员登录
6. 查询电影列表并保存 movie_id
7. 多条件筛选电影
8. 查询电影详情
9. 查询热门电影
10. 查询影院
11. 查询未来场次并保存 schedule_id
12. 查询座位并保存 seat_id
13. 锁定座位
14. 创建订单并保存 order_id
15. 相同幂等键重复下单
16. 查询订单列表
17. 查询订单详情
18. 支付成功
19. 相同流水号重复支付
20. 保存评分评论
21. 查询评论
22. 热门推荐
23. 个性化推荐
24. 删除评论（可选）
25. 退款
26. 查询退款后的座位
27. 执行统计接口
28. 管理员权限检查
29. 管理员创建电影
30. 管理员创建影院
31. 管理员创建场次
32. 验证自动生成座位数
33. 权限与边界异常用例
```

涉及取消订单和支付失败的请求建议单独建立两个子文件夹，不要混进首次主链路，否则会提前释放主链路座位。

### 14.1 Runner 设置

1. 点击 Collection 右侧菜单。
2. 选择 **Run collection**。
3. 勾选正确的请求和执行顺序。
4. Environment 选择 `CineFlow Local`。
5. Iterations 第一次设置为 `1`。
6. Delay 可设置为 `100ms`。
7. 点击 **Run CineFlow API 完整测试**。

主链路会改变数据库状态，多次迭代前必须确保每轮重新查询可用座位并生成新的幂等键与支付流水号。

## 十五、常见失败排查

| 现象 | 可能原因 | 处理方式 |
|---|---|---|
| `ECONNREFUSED 127.0.0.1:8000` | 后端未启动或端口错误 | 先访问 `/health` 和 `/docs` |
| 401 缺少 token | 未执行登录或环境未选中 | 检查 `user_token` / `admin_token` |
| 401 token 无效 | 后端重启后 JWT Secret 改变、Token 被修改 | 重新登录保存 Token |
| 403 管理员接口失败 | 使用了普通用户 Token | 改用 `{{admin_token}}` |
| 场次数组为空 | 演示场次已经过期 | 管理员创建新的未来场次 |
| 没有可用座位 | 座位被锁定、售出或前一轮未清理 | 退款/取消订单或创建新场次 |
| 下单返回 409 | 座位已售或被其他用户锁定 | 重新查询并保存 AVAILABLE 座位 |
| 下单重复却产生不同订单 | Pre-request 每次生成了新幂等键 | 重复请求中删除 Pre-request |
| 重复支付返回 409 | 重复请求生成了新流水号 | 使用原 `trade_no`，删除 Pre-request |
| 评论返回 403 | 当前用户没有该电影的已支付订单 | 先完成支付成功步骤 |
| 统计结果为空 | 对应统计表未导入数据，或演示数据本身较少 | 在 DataGrip 检查 4 张保留统计表行数 |
| Postman 变量显示红色 | 环境未选择或前置请求未执行 | 选择环境并按顺序执行 |
| 返回 422 | JSON 字段名、类型或范围不符合 Pydantic | 对照本文 Body 和 Swagger Schema |

## 十六、测试完成标准

- [ ] `/health` 返回 UP。
- [ ] 注册、登录及 Token 保存成功。
- [ ] 错误密码、缺 Token、伪造 Token 和越权均被拒绝。
- [ ] 电影筛选、分页、详情和热门榜单断言通过。
- [ ] 能获取未来场次和可用座位。
- [ ] 锁座后状态为 LOCKED。
- [ ] 相同幂等键只产生一个订单。
- [ ] 支付后订单为 PAID、座位为 SOLD。
- [ ] 相同支付流水号只产生一个支付事件。
- [ ] 已购票用户可以评论，未购票用户不能评论。
- [ ] 推荐结果数量正确、无重复、无下架电影。
- [ ] 退款或取消后座位恢复 AVAILABLE。
- [ ] 6 个统计接口均返回正确结构。
- [ ] 管理员可以创建电影、影院和未来场次。
- [ ] 普通用户访问管理员接口返回 403。
- [ ] Postman 结果与 DataGrip 数据库查询一致。

当以上项目全部完成后，可以保存 Collection Runner 结果、主链路请求响应和数据库状态截图，作为项目演示与简历证明材料。
