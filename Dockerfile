FROM python:alpine

LABEL maintainer="maxbeiner@gmail.com"
WORKDIR app

ADD Pipfile* /app/

ENV PIPENV_VENV_IN_PROJECT true

RUN apk --no-cache --update add ca-certificates gcc && \
    update-ca-certificates && pip install -U pipenv && \
    apk add --no-cache --update --virtual dev-deps gcc python-dev \
    g++ build-base linux-headers && pipenv sync && \
    apk del dev-deps

ADD . /app

RUN chmod 500 run.sh && adduser -D flask && \
    chown -R flask:flask /app

USER flask

EXPOSE 8000

CMD sh run.sh
