# My App

We use a custom nginx container to serve the static files built by Elm.

For development, start the container (which starts nginx, due to the base image
being nginx). For development we use a different nginx.conf which *doesn't* use
SSL certificates or redirect port 80 to 443.
```sh
docker run --rm --name myapp --network explodinglabs --publish 80:80 -v ${PWD}/nginx-dev.conf:/etc/nginx/nginx.conf -v ${PWD}/docs:/usr/share/nginx/html ghcr.io/explodinglabs/myapp  |grep -v '"HEAD '
```

Run `elm make --output docs/elm.js` to build the app. (For me, this happens
when I save in Vim).

Visit [http://localhost/](http://localhost/).

## Production

For Github Pages, simply commit to `main` and push. It will serve the contents
of `docs`.

For Dockerised production, mount the LetsEncrypt keys into the container, and
expose port 443:
```sh
docker run -d --name myapp --network explodinglabs --publish 80:80 --publish 443:443 -v /etc/letsencrypt/live/mydomain.com/fullchain.pem:/certs/fullchain.pem -v /etc/letsencrypt/live/mydomain.com/privkey.pem:/certs/privkey.pem ghcr.io/explodinglabs/myapp
```

To build the image:
```sh
docker build -t ghcr.io/explodinglabs/myapp .
```
