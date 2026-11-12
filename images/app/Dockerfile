FROM python:3.12-alpine

# The version is the release. The tenant file selects it by tag.
ARG APP_VERSION=dev
ENV APP_VERSION=${APP_VERSION}

COPY app.py /app.py
EXPOSE 8080
USER 65534
CMD ["python3", "-u", "/app.py"]
