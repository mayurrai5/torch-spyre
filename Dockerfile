FROM us.icr.io/wxpe-cicd-internal/amd64/torch-aiu-runtime-dev
USER root

WORKDIR /app
COPY . .

RUN pip install --upgrade pip
RUN pip install .

CMD ["python"]
