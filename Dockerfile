FROM ubuntu:16.04

RUN apt-get update && apt-get install -y apache2
CMD /usr/sbin/apachectl -D FOREGROUND
