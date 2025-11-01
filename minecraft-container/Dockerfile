FROM arm64v8/amazoncorretto:25-alpine

RUN apk update && apk upgrade

WORKDIR /minecraft_server

COPY ./server/server.jar server.jar

COPY ./server/set-properties.sh set-properties.sh
COPY ./server/start-server.sh start-server.sh
COPY ./server/start.sh start.sh

ENTRYPOINT [ "./start.sh" ]
