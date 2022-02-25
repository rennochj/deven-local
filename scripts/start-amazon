#!/bin/bash

docker-compose --file config/deven-amazon-docker-compose.yml up --build -d
docker-compose --file config/deven-amazon-docker-compose.yml exec -T -u deven deven bash -c 'sudo chown deven:deven /var/run/docker.sock' > ~/.ssh/id_rsa

rm -f ~/.ssh/id_rsa
docker-compose --file config/deven-amazon-docker-compose.yml exec -T -u deven deven bash -c 'cat ~/.ssh/id_rsa' > ~/.ssh/id_rsa
chmod 400 ~/.ssh/id_rsa
ssh-keygen -R 127.0.0.1

if [[ -z "${SSH_PORT}" ]]; then

    echo "To access this container use - 'ssh deven@127.0.0.1'"

else

    echo "To access this container use - 'ssh deven@127.0.0.1 -p ${SSH_PORT}'"

fi
