FROM arm64v8/amazoncorretto:25-alpine

RUN apk update && apk upgrade

WORKDIR /minecraft_server

COPY ./src/server/server.jar server/server.jar

COPY ./src/set-properties.sh set-properties.sh
COPY ./src/start-server.sh start-server.sh
COPY ./src/start.sh start.sh

WORKDIR /minecraft_server/server

ENTRYPOINT [ "../start.sh" ]
