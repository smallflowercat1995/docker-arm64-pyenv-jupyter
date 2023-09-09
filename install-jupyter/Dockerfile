FROM debian:11

ADD package /root/

RUN bash /root/install.sh ; rm -rfv /root/install.sh

CMD ["/usr/bin/env","bash","run_jupyter"]
