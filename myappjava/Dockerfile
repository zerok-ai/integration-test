FROM openjdk:14
ENV PORT 3000
EXPOSE 3000
COPY target/*.jar /opt/app.jar
WORKDIR /opt
CMD ["java", "-jar", "app.jar"]