FROM durosoft/crystal-alpine:latest

ADD . /app
CMD crystal run /app/src/watch.cr
