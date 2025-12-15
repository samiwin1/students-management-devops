FROM openjdk:17-jdk-slim
EXPOSE 8089
COPY target/gestion-station-ski-1.0.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
