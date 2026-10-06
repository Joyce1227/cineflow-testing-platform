---
document_id: payment_rules_v1
title: CineFlow 支付规则
version: "1.0"
updated_at: "2026-09-28"
source: CineFlowAPI/app/services/ticket_service.py
owner: CineFlow 项目
status: active
---

# CineFlow 支付规则

## 适用范围

本文描述支付回调、支付幂等和支付后的状态变化。支付属于敏感写操作，RAG 只能解释规则，不得自动发起支付回调。

## 支付回调输入

- 支付回调针对当前登录用户所属的订单。
- `providerTradeNo` 是支付服务商交易号，长度必须为 1 到 64 个字符。
- `success` 表示支付是否成功。

## 幂等规则

- `providerTradeNo` 在支付事件表中具有唯一性，用于防止同一个支付回调被重复记账。
- 如果系统已经处理过相同的 `providerTradeNo`，再次收到该交易号时直接返回订单，不重复修改订单、座位或电影热度。
- 支付重试和回调重放必须复用同一交易号，不能通过生成新交易号绕过幂等控制。

## 支付成功

- 只有状态为 `PENDING_PAYMENT` 的订单可以完成成功支付；其他状态返回冲突错误。
- 支付成功后，订单状态变为 `PAID` 并记录支付时间。
- 订单关联座位从 `LOCKED` 变为 `SOLD`，锁定过期时间被清除。
- 支付成功后，对应电影热度增加 1。

## 支付失败

- 支付失败事件也会被记录，以便同一交易号保持幂等。
- 支付失败后，订单状态变为 `PAYMENT_FAILED`。
- 订单关联座位恢复为 `AVAILABLE`，并清除锁定用户、锁定过期时间和订单关联。

## 安全边界

- 模型不得根据自然语言请求直接执行支付、伪造支付成功或生成支付交易号。
- 某个订单是否已经支付属于实时事实，必须查询订单接口或数据库。
- 文档、Prompt 和日志中不得保存真实支付凭证、JWT、密码或 API Key。
