FROM debian:buster-slim
WORKDIR /prometheus-mining
ADD ./ /prometheus-mining
RUN apt-get update; \
apt-get install -y --no-install-recommends netcat-traditional jq curl lighttpd
ADD ./lighttpd.conf /etc/lighttpd/lighttpd.conf
CMD [ "./server.sh" ]
