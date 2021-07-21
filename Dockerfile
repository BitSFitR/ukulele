FROM azul/zulu-openjdk-alpine:11 AS build
WORKDIR /build
COPY . .
RUN sh gradlew --no-daemon build

FROM azul/zulu-openjdk-alpine:11-jre-headless
RUN apk add --no-cache tini
WORKDIR /app
COPY --from=build /build/build/libs/ .
WORKDIR /data
VOLUME /data
ENTRYPOINT ["/sbin/tini", "--", "/usr/bin/java", "-jar","/app/ukulele.jar"]
