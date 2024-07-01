FROM --platform=linux/arm64/v8  alpine:latest

ADD package /notebook/

RUN cd /notebook/ ; sh init.sh ; rm -fv install.sh init.sh

WORKDIR /notebook

CMD ["bash","run_jupyter"]
