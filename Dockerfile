FROM ruby:2.5.8

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qq && \
    apt-get install -y \
    build-essential \
    libpq-dev \
    node.js yarn
RUN mkdir /myapp

ENV HOME /myapp
WORKDIR $HOME

COPY ./Gemfile $HOME/
COPY ./Gemfile.lock $HOME/

ENV Bundler version 2.0.2
RUN gem install bundler && bundle

COPY package.json .
COPY yarn.lock .
RUN yarn install --check-files
ADD . $HOME
