FROM ruby:2.6.5

# Install dependencies required by rails
# The first part is required by yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg \
  | APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" \
  | tee /etc/apt/sources.list.d/yarn.list \
  # Do the actual install
  && apt-get update -qq && apt-get install -y nodejs postgresql-client yarn

RUN apt-get install -y parallel
RUN echo "will cite\n" | parallel --citation &>/dev/null # Tell parallel that we will,
# in fact, cite it if we use
# it in an academic publication


# Fixes a rails-specific issue, see https://docs.docker.com/compose/rails/
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Change the working directory of the container
RUN mkdir -p /srv && chown www-data /srv
WORKDIR /srv

RUN mkdir -p tmp && chown www-data tmp
RUN mkdir -p log && chown www-data log

# Switch to non-privileged user
RUN mkdir -p /var/www && chown www-data /var/www
#USER www-data

# Install gems
COPY --chown=www-data Gemfile Gemfile.lock ./
RUN bundle install

# Install npm packages
COPY --chown=www-data package.json ./package.json
COPY --chown=www-data yarn.lock ./yarn.lock
RUN yarn install --check-files

# Copy source code into container
COPY --chown=www-data . .

# Start the server on container startup
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]
