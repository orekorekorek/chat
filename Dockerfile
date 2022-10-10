FROM ruby:2.7-slim
WORKDIR /code
RUN apt update -qq && \
    apt install --no-install-recommends -yqq  \
      nodejs \
      git
COPY Gemfile ./
COPY Gemfile.lock ./
RUN apt install --no-install-recommends -yqq libpq-dev sqlite3 libsqlite3-dev
RUN apt-get install build-essential patch zlib1g-dev liblzma-dev -y
RUN apt install libxml2 -y
RUN export NOKOGIRI_USE_SYSTEM_LIBRARIES=true
RUN gem install bundler:1.16.0.pre.3
RUN bundle install
