#!/bin/bash

docker volume create deven-vol
docker-compose --file config/deven-vol-docker-compose.yml run deven-git clone $1 /code/$2
