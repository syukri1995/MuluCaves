FROM ubuntu:24.04 AS build
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y openjdk-21-jdk maven && rm -rf /var/lib/apt/lists/*
WORKDIR /workspace

COPY pom.xml ./
COPY src ./src

RUN mvn -B -DskipTests clean package

FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y openjdk-21-jdk tomcat10 && rm -rf /var/lib/apt/lists/*
WORKDIR /var/lib/tomcat10/webapps

COPY --from=build /workspace/target/mulu-caves.war /var/lib/tomcat10/webapps/mulu-caves.war

EXPOSE 8080
CMD ["/usr/share/tomcat10/bin/catalina.sh", "run"]
