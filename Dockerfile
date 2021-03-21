FROM debian:10

MAINTAINER James Biviano <jamestbiv@gmail.com>

RUN apt-get update && apt-get install -y supervisor postfix dovecot-imapd websockify

EXPOSE 25 8025 8143

# SSL Generation
# openssl req -new -x509 -days 365 -nodes -out self.pem -keyout self.pem 
COPY self.pem self.pem

# Supervisord
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Postfix Config
COPY postfix-main.cf /etc/postfix/main.cf
COPY postfix-master.cf /etc/postfix/master.cf

# Dovecot Config
COPY dovecot-conf-10-master.conf /etc/dovecot/conf.d/10-master.conf
COPY dovecot-conf-10-auth.conf /etc/dovecot/conf.d/10-auth.conf

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
