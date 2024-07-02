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
COPY --from=build /client/dist /var/www



# Copy error page
COPY .docker/error.html /usr/share/nginx/html

# Copy our custom nginx config
COPY .docker/nginx.conf /etc/nginx/nginx.conf

# Copy our custom javascript config template
COPY .docker/config.js.template /etc/nginx/config.js.template

# Copy custom entrypoint for variable substitutions
COPY .docker/docker-entrypoint.sh /

EXPOSE 80

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]