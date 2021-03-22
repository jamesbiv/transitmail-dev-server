# TransitMail Development Server

> <b>Note</b>: This repository is meant for development purposes only. Production use will require a valid SSL certificate and may require other settings and services.

The Dockerfile is based on a Debain 10 (buster) and contains the following services:

<ul>
<li>Postfix (SMTP)</li>
<li>Dovecot (IMAP)</li>
<li>WebSockify</li>
<li>Supervisord</li>
</ul>

## Server features

The server configuration supports the following features:

<ul>
<li>WebSocket service located on port 8025 for SMTP</li>
<li>WebSocket service located on port 8143 for IMAP</li>
<li>SMTP 25 is protected by STARTSSL</li>
<li>Add and remove users</li>
<li>Send to localhost or myhostname</li>
<li>Customise myhostname</li>
<li>Log output for both Dovecot and Postfix</li>
</ul>

## Installation

### 1. Clone this repository

```
git clone https://github.com/jamesbiv/transitmail-dev-server
```

### 2. Install a SSL certificate

### a) Create self a signed certificate (for dev purposes only)

To generate the self signed certificate, run the followng:

```
openssl req -new -x509 -days 365 -nodes -out self.pem -keyout self.pem
```

> <b>Note:</b> Using a self signed certificate will create an invalid certificate error within most browsers. See the section on `Invalid certificate errors` below for a solution to the error.

### b) Use LetsEncrypt or BYO SSL certficate

> <b>Note:</b> `/self.pem` is the file path set for both Postfix and WebSockify configurations.

### 3. Build the Dockerfile image

```
docker build -t transitmail .
```

### 3. Build the Dockerfile container

```
docker create --name transitmail -p 25:25 -p 8025:8025 -p 8143:8143 transitmail
```

### 3. Start the server

```
docker start transitmail
```

## Usage

### Change hostname

```
docker exec -it transitmail postconf myhostname=<NEW HOSTNAME>
docker exec -it transitmail /bin/bash -c "echo <NEW HOSTNAME> > /etc/mailname"
```

> <b>Note</b>: You'll need to reset the server using `docker restart transitmail`

### Create a new user

```
docker exec -it transitmail adduser <USERNAME>
docker exec -it transitmail newaliases
```

### Remove user

```
docker exec -it transitmail deluser <USERNAME>
docker exec -it transitmail newaliases
```

### View Postfix logs

```
docker exec -it transitmail
```

### View Dovecot logs

```
docker exec -it transitmail
```

## Troubleshooting

### Invalid certificate errors

When using an SSL certificate without a valid Certificate Authority (CA). Web browser security will prevent the WebSocket endpoints from accessed and will throw an <b>invalid certificate</b> exception.

In Chrome you can bypass this exception by visiting one of the WebSocket endpoints, for example <b>https://\<HOSTNAME or IP\>:8085</b> and typing the easter egg `thisisunsafe`.

## Further information

Please see the TransitMail client repository at [jamesbiv/transitmail-client](https://github.com/jamesbiv/transitmail-client).
