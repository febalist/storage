FROM alpine:3.10

RUN apk --no-cache add bash py3-pip && pip3 install --no-cache-dir awscli

ADD storage.sh /

ENTRYPOINT ["bash", "/storage.sh"]

CMD ["backup_loop"]
