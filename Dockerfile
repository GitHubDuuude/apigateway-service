# ---------- Etapa 1: compilar ----------
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app

# Copiar solo el pom primero para aprovechar el caché de dependencias
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copiar el código y compilar
COPY src ./src
RUN mvn clean package -DskipTests -B

# ---------- Etapa 2: ejecutar ----------
FROM eclipse-temurin:21-jre
WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]