# CineFlow Web 用户端

Vue 3 + TypeScript + Vite 用户端，配套 `CineFlowAPI` FastAPI 后端，并针对 Selenium Web 自动化测试提供稳定元素定位。

## 已实现页面

- 首页：热门电影、电影筛选、分页、空状态和异常状态
- 用户：注册、登录、退出、Token 失效处理和访问拦截
- 购票：电影详情、场次、可视化选座、锁座、确认订单
- 订单：订单列表、状态筛选、模拟支付、取消和退款
- 互动：电影评论、热门推荐和个性化推荐
- 通用：加载状态、接口错误、404 页面和响应式布局

## 管理端

管理员登录后可以通过头像菜单进入 `/admin`：

- 控制台：API健康状态、电影/影院数量、评分与片长统计、演员作品数
- 电影管理：查看可售电影并新增电影
- 影院管理：查看营业影院并新增影院
- 场次管理：选择电影和影院创建场次，同时自动生成指定行列的座位
- 权限控制：未登录跳转登录页，普通用户访问管理路由显示403页面

演示管理员：`admin / Admin123`。

当前 FastAPI 管理接口只提供新增能力，因此前端没有虚构编辑、删除和下架接口；后续增加对应后端 API 后可以继续扩展。

## 启动

先启动 FastAPI（默认 `127.0.0.1:8000`）：

```powershell
cd D:\MovieTicketingAndRecommendationSystem\CineFlowAPI
.\.venv\Scripts\python.exe -m uvicorn app.main:app --reload
```

再启动 Vue：

```powershell
cd D:\MovieTicketingAndRecommendationSystem\CineFlowWeb
npm install
npm run dev
```

浏览器访问 `http://127.0.0.1:5173`。

演示用户：`test_user / Test1234`。

## Selenium 定位约定

核心元素全部使用稳定的 `data-testid`，不要依赖易变化的 CSS 类名或中文文本。例如：

```python
driver.find_element(By.CSS_SELECTOR, '[data-testid="login-username"]')
driver.find_element(By.CSS_SELECTOR, '[data-testid="login-password"]')
driver.find_element(By.CSS_SELECTOR, '[data-testid="login-submit"]')
```

动态元素也采用固定规则：

```text
movie-card-{movieId}
choose-schedule-{scheduleId}
seat-{seatId}
order-card-{orderId}
order-detail-{orderId}
```

建议测试中优先使用显式等待，等待目标元素可见或可点击，不使用固定 `sleep`。

## 构建检查

```powershell
npm run build
```

构建产物生成在 `dist`，该命令同时执行 Vue TypeScript 类型检查。
