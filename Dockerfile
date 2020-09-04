FROM rguna1204/edm_07152020

MAINTAINER gunasekaran.rajamani@cudirect.com 

RUN apt-get update 
RUN apt-get install –y nginx 
CMD [“echo”,”Image created”] 