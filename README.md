# `php-docker-image`

This repository contains a general-purpose base PHP docker image for use in Bluewing applications that combines the lightweight base image of Alpine Linux with the speed-wins normally gained through using Debian.

## Rationale

Alpine Linux PHP docker images are typically 6× smaller in size or more, which makes them an excellent choice due to their lightweight footprint. They do however come with the disadvantage that [they ship with musl libc instead of glib and friends](https://hub.docker.com/_/php). This means that the PHP extensions we need as part of our application stack must be compiled from source, installed of installed from a precompiled binary, which significantly slows the build time—up to 800 seconds or more to build a base image with the dependencies we need.

We have extracted these long build times to an infrequently-modified Docker image that can be built once in CI and pulled as much as necessary.

## Available tags

Two image variants are available, a primary image that requires in `pdo_pgsql` and `phpredis` so we can use a development image tagged `dev` which additionally includes `xdebug`.

| Tag                 | PHP version | Alpine Version | Extensions                                | Build size |
|---------------------|-------------|----------------|-------------------------------------------|------------|
| `dev-8.1.4-latest`  | 8.1.4       | 3.15           | `pdo_pgsql`,`redis-5.3.7`, `xdebug-3.1.5` |            |
| `main-8.1.4-latest` | 8.1.4       | 3.15           | `pdo_pgsql`, `redis-5.3.7`,               |            |

Each flavour of image is tagged three times, making it possible to select images based purely on the latest version, the latest version of a specific PHP release, or a specific image entirely:

* `FLAVOR-latest`
* `FLAVOR-PHP_VERSION-latest`
* `FLAVOR-PHP_VERSION-DATE`

PHP extensions are installed using the [thecodingmachine/docker-images-php](https://github.com/thecodingmachine/docker-images-php) Docker image.

## Building

Each image is built when a release occurs, using GitHub Actions, and published to GitHub Container Registry. To use these images in your `Dockerfile`, reference them as follows:

```Dockerfile
# Development, includes xdebug along with other extensions. 
FROM ghcr.io/bluewing/php-docker-image:dev-latest
# Production, only pdo_pgsql and redis
FROM ghcr.io/bluewing/php-docker-image:main-latest
```