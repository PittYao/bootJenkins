FROM openjdk:8-jdk-alpine
ARG JAR_FILE
COPY ${JAR_FILE} app.jar
#EXPOSE 10086
ARG PORT=8080
ENTRYPOINT ["java","-jar","/app.jar","--server.port=${PORT}"]
