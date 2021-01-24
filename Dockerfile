FROM    debian:stable

RUN apt-get update && apt-get install -y \
    adduser \
    git \
    cron \
    rsync \
    nginx

RUN mkdir -p /opt/guluc3m/

RUN adduser \
    --system \
    --home=/opt/guluc3m/ \
    --shell=/bin/bash \
    --no-create-home \
    --group \
    archvsync

RUN mkdir -p /srv/mirrors/
RUN chown -R archvsync: /srv/mirrors
VOLUME ["/srv/mirrors"]

RUN ln -s /srv/mirrors /var/www/mirrors
ADD ftp.gul.es /etc/nginx/sites-available/ftp.gul.es
RUN ln -s /etc/nginx/sites-available/ftp.gul.es /etc/nginx/sites-enabled/ftp.gul.es
RUN rm /etc/nginx/sites-available/default
RUN rm /etc/nginx/sites-enabled/default
RUN service nginx start

WORKDIR /opt/guluc3m/
RUN git clone https://github.com/guluc3m/ftpsync.git
RUN chown -R archvsync:archvsync ./ftpsync
WORKDIR /opt/guluc3m/ftpsync/bin/
RUN chmod +x ./ftpsync

ADD crontab /etc/cron.d/mirror-cron
RUN chmod 0644 /etc/cron.d/mirror-cron
RUN crontab /etc/cron.d/mirror-cron
RUN touch /var/log/cron.log
RUN chown archvsync:archvsync /var/log/cron.log

CMD cron && tail -f /var/log/cron.log
#ENV PATH /opt/guluc3m/ftpsync/bin:${PATH}

#CMD cron
#CMD [cron && service nginx restart && "/bin/su -c "/bin/bash ftpsync/bin/ftpsync sync:all" - archvsync"]
#COPY start.sh start.sh
#RUN chmod +x start.sh
#CMD ["./start.sh"]
