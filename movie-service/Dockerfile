FROM openjdk:17-jdk-alpine
WORKDIR /app
COPY target/movie-service.jar ./movie-service.jar
EXPOSE 8080
CMD ["java", "-jar", "movie-service.jar"]

