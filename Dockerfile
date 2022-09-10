# syntax = docker/dockerfile:1.2

# This `Dockerfile` has two possible build outputs: `dev` and `main`.

FROM php:8.1.4-fpm-alpine3.15 as base
LABEL maintainer="lukedavia@icloud.com"
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/


FROM base as main
RUN install-php-extensions pdo_pgsql redis-5.3.7;

FROM main as dev
RUN install-php-extensions xdebug-3.1.5;
