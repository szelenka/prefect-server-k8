#!/usr/bin/env bash

# locate javascript files
for filename in "${APP_ROOT_SRC:-/var/www}/js/"*.js*; do
  echo "inspecting ${filename}"
#  if [ -z "${VUE_APP_GRAPHQL_HTTP}" ]; then
#    VUE_APP_GRAPHQL_HTTP="process.env.VUE_APP_GRAPHQL_HTTP || 'http://localhost:4200/graphql'"
#  fi
#  sed -i -e "s|process.env.VUE_APP_GRAPHQL_HTTP|'${VUE_APP_GRAPHQL_HTTP}'|g" ${filename}
  if [ -z "${PREFECT_SERVER__APOLLO__HOST}" ]; then
    PREFECT_SERVER__APOLLO__HOST="localhost:5555"
  fi
  sed -i -e "s|localhost:4200|${PREFECT_SERVER__APOLLO__HOST}|g" ${filename}
done

exec nginx -g "daemon off;" -c /etc/nginx/conf.d/default.conf