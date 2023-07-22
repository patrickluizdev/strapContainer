FROM node:14

WORKDIR /usr/src/app

# variáveis de ambiente para o banco de dados
ENV $APP_NAME=strapi
ENV DB_CLIENT=postgres
ENV DB_HOST=postgres
ENV DB_PORT=5432
ENV DB_NAME=app
ENV DB_USERNAME=root
ENV DB_PASSWORD=toor
ENV DB_SSL=false

RUN /bin/bash -c 'yarn create strapi-app "$APP_NAME" --dbclient="$DB_CLIENT" --dbhost="$DB_HOST" --dbport="$DB_PORT" --dbname="$DB_NAME" --dbusername="$DB_USERNAME" --dbpassword="$DB_PASSWORD" --dbssl="$DB_SSL" --dbforce'

# Utilização do arquivo com script
# COPY ./start.sh /usr/src/
# RUN chmod +x ../start.sh

WORKDIR /usr/src/app/$APP_NAME

EXPOSE 1337

CMD ["yarn" "develop"]