FROM openjdk:8-jre-alpine

LABEL app="$PROJECT_NAME"
LABEL version="$PROJECT_VERSION"

ENV SPRING_PROFILES_ACTIVE docker

WORKDIR /app

COPY app/* ./

ENTRYPOINT ["./docker-entrypoint.sh"]
