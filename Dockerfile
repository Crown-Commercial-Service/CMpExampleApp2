FROM ruby:2.5-alpine

# Build information
ARG GIT_COMMIT=unspecified
LABEL git_commit=$GIT_COMMIT

ENV BUILD_PACKAGES curl-dev ruby-dev sqlite-dev build-base

# Update and install base packages
RUN apk update && apk upgrade && apk add bash $BUILD_PACKAGES nodejs

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

# Create app directory
WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

EXPOSE 8080

CMD ["ruby", "bin/rails", "server"]