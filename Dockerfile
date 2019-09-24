FROM durosoft/crystal-alpine:latest

RUN apk add --update tzdata

ADD . /app
CMD crystal run /app/src/todoist_watch.cr
