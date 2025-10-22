# syntax=docker/dockerfile:1
ARG RUBY_VERSION=3.1.2
FROM ruby:$RUBY_VERSION-slim as base

WORKDIR /rails

ENV RAILS_ENV=production \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT=development:test

# ----------------------
# Build stage
# ----------------------
FROM base as build

# Install build dependencies
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    build-essential curl git libpq-dev libvips nodejs npm pkg-config python-is-python3

# Copy Gemfiles and install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    bundle exec bootsnap precompile --gemfile

# Copy JS dependencies and install
COPY package.json yarn.lock ./
RUN npm install -g yarn && yarn install --frozen-lockfile

# Copy the app code
COPY . .

# Precompile bootsnap for faster boot
RUN bundle exec bootsnap precompile app/ lib/

# Precompile assets without DB
ENV DATABASE_URL=postgres://dummy:dummy@localhost/dummy
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile
ENV DATABASE_URL=

# ----------------------
# Final runtime stage
# ----------------------
FROM base

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends curl libvips postgresql-client && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/*

# Copy gems and app from build
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Non-root user
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER rails:rails

# Entrypoint
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

EXPOSE 3000
CMD ["./bin/rails", "server"]
