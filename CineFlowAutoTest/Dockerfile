FROM python:3.12-slim
WORKDIR /workspace/CineFlowAutoTest
COPY CineFlowAutoTest/requirements.txt ./requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
COPY CineFlowAutoTest /workspace/CineFlowAutoTest
COPY CineFlowAPI/app /workspace/CineFlowAPI/app
COPY docs/api/cineflow-openapi.json /workspace/docs/api/cineflow-openapi.json
CMD ["pytest"]

