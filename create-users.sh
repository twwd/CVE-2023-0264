#!/usr/bin/env bash
set -euo pipefail

BEARER=$(curl -s -k http://localhost:8080/realms/master/protocol/openid-connect/token -X POST --data 'grant_type=password&username=admin&password=admin&client_id=admin-cli' | jq -r '.access_token')

for user in alice mallory; do
  printf "Create user %s\n" $user
  curl -s 'http://localhost:8080/admin/realms/test/users' -X POST -H "authorization: Bearer $BEARER" -H 'content-type: application/json' --data-raw "{\"username\":\"$user\",\"email\":\"\",\"firstName\":\"\",\"lastName\":\"\",\"requiredActions\":[],\"emailVerified\":false,\"groups\":[],\"enabled\":true}"
  user_id=$(curl -s -k "http://localhost:8080/admin/realms/test/users?username=$user&exact=true" -X GET -H "authorization: Bearer $BEARER" | jq -r '.[0].id')
  curl -s "http://localhost:8080/admin/realms/test/users/$user_id/reset-password" -X PUT -H "authorization: Bearer $BEARER" -H 'content-type: application/json' --data-raw '{"temporary":false,"type":"password","value":"test"}'
  printf '\n'
done
