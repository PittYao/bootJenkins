FROM openjdk:8-jdk-alpine
ARG JAR_FILE
COPY ${JAR_FILE} app.jar
#EXPOSE 10086
ARG SERVER_PORT
ENTRYPOINT ["java","-jar","/app.jar","--server.port=${SERVER_PORT}"]
