FROM ubuntu:latest

RUN apt-get update
RUN apt-get install wget apt-transport-https gnupg -y
RUN wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add -
RUN echo "deb https://adoptopenjdk.jfrog.io/adoptopenjdk/deb "$(cat /etc/os-release | grep UBUNTU_CODENAME | cut -d = -f 2)" main" | tee /etc/apt/sources.list.d/adoptopenjdk.list
RUN apt-get update
RUN apt-get install adoptopenjdk-11-hotspot -y
RUN apt-get install git -y
RUN git clone https://github.com/spring-projects/spring-petclinic.git
WORKDIR /spring-petclinic
ENV MYSQL_URL=jdbc:mysql://a2:3306/petclinic
RUN ./mvnw -DskipTests=true package
ENTRYPOINT java -jar -Dspring.profiles.active=mysql target/*.jar
