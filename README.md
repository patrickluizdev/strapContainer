# Strapi Docker Compose

Este é um container para configurar e executar um aplicativo Strapi com um banco de dados PostgreSQL usando Docker.

## Pré-requisitos

Antes de usar este arquivo, certifique-se de ter instalado o Docker e o Docker Compose em seu sistema. Além disso, verifique se os seguintes diretórios estão criados e possuem as permissões adequadas:

1. Diretório `./postgres`: Este diretório será usado para armazenar os dados persistentes do PostgreSQL.

2. Diretório `./strapi`: Este diretório será usado para armazenar os dados persistentes do aplicativo Strapi.

## Instruções

1. Crie os diretórios `./postgres` e `./strapi` com as permissões corretas:

```bash
mkdir ./postgres ./strapi
```

2. Copie o conteúdo abaixo para o arquivo `docker-compose.yml` na raiz do seu projeto:

```yaml
version: '3'
services:
  postgres:
    image: postgres:latest
    container_name: postgres-db
    restart: always
    ports:
      - '5432:5432'
    environment:
      POSTGRES_USER: root
      POSTGRES_PASSWORD: toor
      POSTGRES_DB: app
    volumes:
      - ./postgres:/var/lib/postgresql/data
    networks:
      - strapi_net

  app:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: app
    restart: always
    volumes:
      - ./strapi:/usr/src/app
    ports:
      - '1337:1337'
    networks:
      - strapi_net

networks:
  strapi_net:
    driver: bridge
```

3. Crie um arquivo `Dockerfile` na raiz do seu projeto com o conteúdo abaixo:

```Dockerfile
FROM node:14

WORKDIR /usr/src/

# Variáveis de ambiente para o banco de dados
ENV APP_NAME=strapi
ENV DB_CLIENT=postgres
ENV DB_HOST=postgres
ENV DB_PORT=5432
ENV DB_NAME=app
ENV DB_USERNAME=root
ENV DB_PASSWORD=toor
ENV DB_SSL=false

RUN /bin/bash -c 'yarn create strapi-app "$APP_NAME" --dbclient="$DB_CLIENT" --dbhost="$DB_HOST" --dbport="$DB_PORT" --dbname="$DB_NAME" --dbusername="$DB_USERNAME" --dbpassword="$DB_PASSWORD" --dbssl="$DB_SSL" --dbforce'

WORKDIR /usr/src/app/$APP_NAME

# Utilização do arquivo com script
# COPY ./start.sh /usr/src/
# RUN chmod +x ../start.sh

EXPOSE 1337

CMD ["yarn", "develop"]
```

4. Execute o comando abaixo para criar e iniciar os contêineres:

```bash
docker-compose up -d
```

Agora seu aplicativo Strapi estará em execução em `http://localhost:1337` e o banco de dados PostgreSQL estará em execução em `localhost:5432`.

Lembre-se de substituir os valores das variáveis de ambiente conforme necessário para corresponder às configurações do seu aplicativo. Além disso, se desejar adicionar um script personalizado (por exemplo, o `start.sh` mencionado anteriormente), você pode descomentar a seção relevante no `Dockerfile` e incluir o script no mesmo diretório que o arquivo `Dockerfile`.


<em> Ao configurar um aplicativo Strapi em uma VPS ou um container com IP externo, é importante o painel administrativo do Strapi está acessível apenas por meio de conexões locais (localhost) por razões de segurança. Isso evita que pessoas não autorizadas acessem o painel administrativo e protege seus dados sensíveis. Para isso, pode-se usar um serviço de proxy, como o [Squid Proxy - Repo](https://github.com/patrickluizdev/proxyWithAuthentication), ou um serviço de proxy reverso que atua como intermediário entre os usuários externos e o servidor Strapi. </em>
