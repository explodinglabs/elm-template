<img
    alt="My App"
    style="margin: 0 auto;"
    src="https://github.com/explodinglabs/my-app/blob/main/logo.png?raw=true"
/>

We use a custom nginx container to serve the static files built by Elm.

Start the container (which starts nginx, due to the base image being nginx).
For development we use a different nginx.conf which *doesn't* use SSL
certificates or redirect port 80 to 443.
```sh
docker run --rm --name my-app --network explodinglabs --publish 80:80 -v ${PWD}/nginx-dev.conf:/etc/nginx/nginx.conf -v ${PWD}/static:/usr/share/nginx/html ghcr.io/explodinglabs/my-app
```

Visit [http://localhost/](http://localhost/).

For production, and mount the LetsEncrypt keys into the container, and expose
port 443:
```sh
docker run -d --name my-app --network explodinglabs --publish 80:80 --publish 443:443 -v /etc/letsencrypt/live/standupmeeting.app/fullchain.pem:/certs/fullchain.pem -v /etc/letsencrypt/live/standupmeeting.app/privkey.pem:/certs/privkey.pem ghcr.io/explodinglabs/standup-web
```

To build the image:
```sh
docker build -t ghcr.io/explodinglabs/my-app .
```
