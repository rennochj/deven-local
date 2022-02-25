#!/bin/bash

docker-compose --file config/deven-alpine-docker-compose.yml up --build -d
docker-compose --file config/deven-alpine-docker-compose.yml exec -T -u deven deven sh -c 'chown deven /var/run/docker.sock'

rm -f ~/.ssh/id_rsa
docker-compose --file config/deven-alpine-docker-compose.yml exec -T -u deven deven sh -c 'cat ~/.ssh/id_rsa' > ~/.ssh/id_rsa
chmod 400 ~/.ssh/id_rsa
ssh-keygen -R 127.0.0.1

if [[ -z "${SSH_PORT}" ]]; then

    echo "To access this container use - 'ssh deven@127.0.0.1'"

else

    echo "To access this container use - 'ssh deven@127.0.0.1 -p ${SSH_PORT}'"

fi
