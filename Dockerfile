FROM rguna1204/edm_07152020

MAINTAINER gunasekaran.rajamani@cudirect.com 

RUN echo "#!/bin/bash\n" > /startscript.sh
RUN echo "mkdir github\n" >> /startscript.sh
RUN echo "cd github\n" >> /startscript.sh
RUN echo "git clone \$github\n" >> /startscript.sh

CMD [“echo”,”Image created”] 