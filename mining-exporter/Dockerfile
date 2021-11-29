FROM debian:buster-slim
WORKDIR /prometheus-mining
ADD ./ /prometheus-mining
RUN apt-get update; \
apt-get install -y --no-install-recommends netcat-traditional jq curl lighttpd
ADD ./lighttpd.conf /etc/lighttpd/lighttpd.conf

RUN adduser --system --home /app app && addgroup app && adduser app app
RUN chown -R app:app /prometheus-mining
USER app

CMD [ "./server.sh" ]
