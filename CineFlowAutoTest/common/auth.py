from common.api_client import ApiClient


def login(client: ApiClient, username: str, password: str) -> str:
    response = client.post("/api/auth/login", json={"username": username, "password": password})
    assert response.status_code == 200, response.text
    body = response.json()
    assert body["code"] == 0, body
    token = body["data"]["token"]
    client.set_token(token)
    return token
