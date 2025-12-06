FROM maven:3.9.6-eclipse-temurin-17-alpine AS build
WORKDIR /app
COPY . .
RUN mvn package -DskipTests

FROM eclipse-temurin:17-jdk-alpine AS package
WORKDIR /app
COPY --from=build /app/target/sysfoo-*.jar ./sysfoo.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "sysfoo.jar"]
