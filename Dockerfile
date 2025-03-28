FROM docker.io/ruby:alpine AS builder

RUN apk add --no-cache g++ make

ADD Gemfile /app/
ADD *gemspec /app/
ADD lib /app/lib/
ADD config.ru /app/

WORKDIR /app
RUN bundle config set --local path 'vendor' \
 && bundle config set --local without 'development' \
 && bundle install

FROM docker.io/ruby:alpine

ENV APP_HOME /app
ENV RACK_ENV production

COPY --from=builder /app $APP_HOME
ADD public $APP_HOME/public/
ADD views $APP_HOME/views/
WORKDIR $APP_HOME

RUN apk add --no-cache libstdc++ \
 && bundle config set --local path 'vendor' \
 && bundle config set --local without 'development'

EXPOSE 9292/tcp
CMD ["bundle", "exec", "thin", "start", "--threaded", "--threadpool-size", "4", "--port", "9292"]
