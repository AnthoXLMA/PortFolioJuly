# syntax=docker/dockerfile:1

# ========================
# Base image Ruby
# ========================
ARG RUBY_VERSION=3.1.2
FROM ruby:$RUBY_VERSION-slim AS base

# Set workdir
WORKDIR /rails

# Set production environment
ENV RAILS_ENV=production \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT="development:test"

# ========================
# Build stage
# ========================
FROM base AS build

# Install dependencies for gems & Node.js
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
        build-essential curl git libpq-dev libvips pkg-config python-is-python3 && \
    rm -rf /var/lib/apt/lists/*

# Install Node.js >=22 and Yarn
ARG NODE_VERSION=22
ARG YARN_VERSION=1.22.22
RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn@$YARN_VERSION

# ========================
# Install gems
# ========================
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 4 && \
    bundle exec bootsnap precompile --gemfile

# ========================
# Install JS dependencies
# ========================
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# ========================
# Copy app code
# ========================
COPY . .

# Precompile bootsnap for faster boot
RUN bundle exec bootsnap precompile app/ lib/

# Precompile Rails assets (without RAILS_MASTER_KEY)
RUN SECRET_KEY_BASE_DUMMY=1 bin/rails assets:precompile

# ========================
# Final runtime image
# ========================
FROM base

# Install runtime dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
        curl libvips postgresql-client && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives

# Copy gems and app from build stage
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Create non-root user
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp

USER rails:rails
WORKDIR /rails

# Entrypoint prepares database
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Expose default Rails port
EXPOSE 3000
CMD ["./bin/rails", "server"]
