# The preliminary stage of building a Docker image
# It includes the tools needed for development
# Additional information about Multi Stage Docker
# https://docs.docker.com/build/building/multi-stage/

FROM        python:3.11-buster as builder

RUN         pip install poetry==1.8.2
ENV         POETRY_NO_INTERACTION=1 \
            POETRY_VIRTUALENVS_IN_PROJECT=1 \
            POETRY_VIRTUALENVS_CREATE=1 \
            POETRY_CACHE_DIR=/tmp/poetry_cache \
            PIP_DISABLE_PIP_VERSION_CHECK=on \
            PIP_DEFAULT_TIMEOUT=100
WORKDIR     /opt
COPY        pyproject.toml ./
RUN -       -mount=type=cache,target=$POETRY_CACHE_DIR poetry install --no-root

# Building the develop environment
# docker build --target develop .

FROM        python:3.11-slim-buster as develop

ENV         VIRTUAL_ENV=/opt/.venv \
            PATH="/opt/.venv/bin:$PATH" \
            PROJECTPATH=/opt/hello
COPY        --from=builder ${VIRTUAL_ENV} ${VIRTUAL_ENV}
COPY        . ${PROJECTPATH}
