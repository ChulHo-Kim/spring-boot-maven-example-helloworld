FROM tomcat:8.5.61-jdk8-openjdk

MAINTAINER Eric.Kim <kch@tangunsoft.com>

COPY target/SpringBootMavenExample-1.3.5.RELEASE.war /usr/local/tomcat/webapps

EXPOSE 8008
CMD ["/usr/local/tomcat/bin/catalina.sh", "run"]