FROM alpine:latest

# # Configure CG apt package libraries ----------------------------------------------------------------------------------
 
RUN apk update 
RUN apk add --upgrade apk-tools && apk upgrade --available
RUN apk add ca-certificates
 
# # Install Git ---------------------------------------------------------------------------------------------------------
 
RUN apk add git
# RUN git config --global http.sslCAInfo /cacert.pem
 
# # Install Docker ------------------------------------------------------------------------------------------------------
 
RUN apk add --update docker docker-compose

ENV DEVEN_PATH "/deven"
COPY scripts "${DEVEN_PATH}/"
COPY containers "${DEVEN_PATH}/"
COPY scripts "${DEVEN_PATH}/"
ENV PATH="${DEVEN_PATH}:${PATH}"

# ENTRYPOINT [ "/bin/ash" ]
 