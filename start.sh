#!/bin/bash

cd /usr/src/
yarn create strapi-app app --dbclient="postgres" --dbhost="postgres" --dbport="5432" --dbname="app" --dbusername="root" --dbpassword="toor" --dbssl=false --dbforce
# Parametros da documentação: https://docs.strapi.io/dev-docs/intro

cd /usr/src/app
yarn develop