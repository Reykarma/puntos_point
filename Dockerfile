ARG RUBY_VERSION=3.1.6
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base
ENV PATH="/usr/local/bundle/bin:${PATH}"

WORKDIR /rails

ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

FROM base as build

# Dependencias corregidas con formato adecuado
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    git \
    libpq-dev \
    libvips-dev \
    pkg-config \
    imagemagick \
    libmagickwand-dev \
    libmagic-dev

COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

COPY . .

RUN bundle exec bootsnap precompile app/ lib/

FROM base

# Dependencias corregidas con formato adecuado
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl \
    libvips \
    imagemagick \
    libmagickwand-dev \
    libmagic-dev \
    postgresql-client && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

RUN useradd rails --create-home --shell /bin/bash && \
    mkdir -p /rails/storage /rails/tmp/storage && \
    chown -R rails:rails db log storage tmp /usr/local/bundle && \
    chmod -R 775 /rails/storage /rails/tmp/storage && \
    echo 'alias rails="./bin/rails"' >> /home/rails/.bashrc
    
USER rails:rails

ENTRYPOINT ["/rails/bin/docker-entrypoint"]

EXPOSE 4000

CMD ["./bin/rails", "server", "-b", "0.0.0.0", "-p", "4000"]