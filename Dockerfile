# Use a lightweight Java runtime image
FROM openjdk:11-jre-slim

# Copy the Spring Boot jar from the target folder into the container
COPY target/demo-0.0.1-SNAPSHOT.jar /app.jar

# Specify the command to run the jar
ENTRYPOINT ["java", "-jar", "/app.jar"]
