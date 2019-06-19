FROM openjdk:8-jdk-alpine

LABEL app="$PROJECT_NAME"
LABEL version="$PROJECT_VERSION"

WORKDIR /app

COPY $PROJECT_JAR .

ENTRYPOINT ["java", "-Dspring.profiles.active=docker", "-jar","$PROJECT_JAR"]
