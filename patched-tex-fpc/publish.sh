docker build --tag helm/my-tex-fpc-development:latest -f development.Dockerfile .
docker build --tag helm/my-tex-fpc:latest -f minified.Dockerfile .
docker image push helm/my-tex-fpc:latest
