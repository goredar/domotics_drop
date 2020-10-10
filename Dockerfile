FROM ruby:2.1

# RUN apk add --no-cache alpine-sdk

COPY ./ /app
WORKDIR /app

RUN bundle install

CMD ruby app.rb
