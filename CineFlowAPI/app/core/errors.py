from fastapi import FastAPI, Request
from fastapi.exceptions import RequestValidationError
from fastapi.responses import JSONResponse
from sqlalchemy.exc import IntegrityError
import logging

logger = logging.getLogger(__name__)


class ApiError(Exception):
    def __init__(self, status_code: int, message: str, code: int | None = None):
        self.status_code = status_code
        self.code = code or status_code
        self.message = message


def envelope(code: int, message: str, data=None) -> dict:
    import time
    return {"code": code, "message": message, "data": data, "timestamp": int(time.time() * 1000)}


def install_error_handlers(app: FastAPI) -> None:
    @app.exception_handler(ApiError)
    async def api_error(_: Request, exc: ApiError):
        return JSONResponse(status_code=exc.status_code, content=envelope(exc.code, exc.message))

    @app.exception_handler(RequestValidationError)
    async def validation_error(_: Request, exc: RequestValidationError):
        messages = [f"{'.'.join(map(str, e['loc'][1:]))}: {e['msg']}" for e in exc.errors()]
        return JSONResponse(status_code=422, content=envelope(422, "; ".join(messages)))

    @app.exception_handler(IntegrityError)
    async def integrity_error(_: Request, __: IntegrityError):
        return JSONResponse(status_code=409, content=envelope(409, "数据冲突，请勿重复提交"))

    @app.exception_handler(Exception)
    async def unexpected_error(_: Request, exc: Exception):
        logger.exception("Unhandled API error", exc_info=exc)
        return JSONResponse(status_code=500, content=envelope(500, "服务器内部错误"))
