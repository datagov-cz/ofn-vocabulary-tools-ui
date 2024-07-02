# BASE STAGE
# Prepare node, copy package.json
FROM node:20 AS base
WORKDIR /client
COPY package.json package-lock.json ./

# DEPENDENCIES STAGE
# Install production and dev dependencies
FROM base AS dependencies
# install node packages
RUN npm set progress=false && npm config set depth 0
RUN npm ci

FROM dependencies AS build
COPY . .
RUN set -ex; npm run build

FROM nginx:latest AS deploy
COPY --from=build /client/dist /usr/share/nginx/html
