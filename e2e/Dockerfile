FROM node:latest

WORKDIR /contractTest

COPY package*.json ./
COPY yarn.lock ./
COPY tsconfig.json ./
COPY tslint.json ./

RUN yarn