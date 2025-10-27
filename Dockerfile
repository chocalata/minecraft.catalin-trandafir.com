FROM amazoncorretto:25
WORKDIR /minecraft_server
# Accepting EULA
RUN echo "eula=true" > eula.txt
COPY ./server.jar server.jar
# java -Xmx1024M -Xms1024M -jar minecraft_server.1.21.10.jar nogui
CMD ["java", "-Xmx1024M", "-Xms1024M", "-jar", "server.jar", "nogui"]
