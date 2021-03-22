FROM debian:10

LABEL maintainer="jamestbiv@gmail.com"

RUN apt-get update && apt-get install -y supervisor postfix dovecot-imapd websockify

EXPOSE 25 8025 8143

# SSL Generation
COPY self.pem self.pem

# Supervisord
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Postfix Config
COPY postfix-main.cf /etc/postfix/main.cf
COPY postfix-master.cf /etc/postfix/master.cf
COPY etc-mailname /etc/mailname

# Dovecot Config
COPY dovecot-conf-10-auth.conf /etc/dovecot/conf.d/10-auth.conf
COPY dovecot-conf-10-master.conf /etc/dovecot/conf.d/10-master.conf
COPY dovecot-conf-10-logging.conf /etc/dovecot/conf.d/10-logging.conf

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
