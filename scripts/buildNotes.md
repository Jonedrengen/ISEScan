# Build notes

## Pull image

```sh
docker pull jonedrengen/isescan:latest
```

## Build image

```sh
docker build --platform linux/amd64 -t jonedrengen/isescan:latest .
```

## Build image (using buildx for multiple architecture)
### TODO: currently does not work for arm64
```sh
docker buildx build --platform linux/amd64,linux/arm64 -t jonedrengen/isescan:latest .
```

## Push image

```sh
docker push jonedrengen/isescan:latest
```

## Run image

```sh
docker run --rm jonedrengen/isescan:latest --help
```
