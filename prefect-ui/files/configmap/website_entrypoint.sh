#!/usr/bin/env bash

# locate javascript files
for filename in "${APP_ROOT_SRC:-/var/www}/js/"*.js*; do
  echo "inspecting ${filename}"
  # replace hard-coded values with HTTP Schema
  if [ -z "${VUE_APP_GRAPHQL_HTTP}" ]; then
    VUE_APP_GRAPHQL_HTTP="http://localhost:4200/graphql"
  fi
  sed -i -e "s|http://localhost:4200/graphql|${VUE_APP_GRAPHQL_HTTP}|g" ${filename}
done

exec nginx -g "daemon off;" -c /etc/nginx/conf.d/default.conf