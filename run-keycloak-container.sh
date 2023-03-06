#!/usr/bin/env bash

docker run -p 8080:8080 -e KEYCLOAK_ADMIN=admin -e KEYCLOAK_ADMIN_PASSWORD=admin -d -v ./realm-data:/opt/keycloak/data/import --name keycloak-vuln quay.io/keycloak/keycloak:21.0.0 start-dev --import-realm