# Build stage
FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app

COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

COPY . .

RUN flutter build web --release


# Serve stage
FROM caddy:2-alpine

COPY --from=build /app/build/web /usr/share/caddy

ENV PORT=8080

EXPOSE 8080

CMD ["sh", "-c", "caddy file-server --listen :$PORT --root /usr/share/caddy"]
