# Build stage
FROM ghcr.io/cirruslabs/flutter:stable AS build
WORKDIR /app
COPY . .
RUN flutter pub get
RUN flutter build web --release

# Serve stage
FROM caddy:2-alpine
COPY --from=build /app/build/web /usr/share/caddy
ENV PORT=8080
EXPOSE 8080
CMD ["sh", "-c", "caddy file-server --listen :$PORT --root /usr/share/caddy"]

FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app

COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

COPY . .

RUN flutter build web --release


FROM nginx:alpine

COPY --from=build /app/build/web /usr/share/nginx/html

RUN printf '%s\n' \
'server {' \
'    listen 8080;' \
'    server_name _;' \
'    root /usr/share/nginx/html;' \
'    index index.html;' \
'' \
'    location / {' \
'        try_files $uri $uri/ /index.html;' \
'    }' \
'}' \
> /etc/nginx/conf.d/default.conf

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]