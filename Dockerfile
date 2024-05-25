# -------------------------------------------------------------------
# Minimal dockerfile from alpine base
#
# Instructions:
# =============
# 1. Create an empty directory and copy this file into it.
#
# 2. Create image with:
#	docker build --tag timeoff:latest .
#
# 3. Run with:
#	docker run -d -p 3000:3000 --name alpine_timeoff timeoff
#
# 4. Login to running container (to update config (vi config/app.json):
#	docker exec -ti --user root alpine_timeoff /bin/sh
# --------------------------------------------------------------------
#Build: docker build -t timeoff-management .

FROM node:13-alpine

EXPOSE 3000

LABEL org.label-schema.schema-version="1.3.0"
LABEL org.label-schema.docker.cmd="docker run -d -p 3000:3000 --name timeoff-management"

RUN apk update
RUN apk upgrade
#Install dependencies
RUN apk add \
    git \
    make \
    python2 \
    g++ \
    gcc \
    libc-dev \
    clang

#Add user so it doesn't run as root
RUN adduser --system app --home /app
USER app
WORKDIR /app

#clone app
RUN git clone https://github.com/timeoff-management/application.git timeoff-management

WORKDIR /app/timeoff-management

#bump formidable up a version to fix user import error.
RUN sed -i 's/formidable"\: "~1.0.17/formidable"\: "1.1.1/' package.json

#install app
RUN npm install -y

CMD npm start
