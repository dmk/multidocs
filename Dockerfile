FROM ruby:2.5.0

ENV APP_HOME=/home/app

# Set the TZ variable to avoid perpetual system calls to stat(/etc/localtime)
ENV TZ=UTC

 # Create group "app" and user "app".
RUN groupadd -r --gid 1000 app \
 && useradd --system --create-home --home ${APP_HOME} --shell /sbin/nologin --no-log-init \
      --gid 1000 --uid 1000 app \
 # Install system dependencies.
 && curl -sL https://deb.nodesource.com/setup_8.x | bash - \
 && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
 && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
 && apt-get update \
 && apt-get install -y \
      nodejs \
      yarn

WORKDIR $APP_HOME

# Install dependencies defined in Gemfile.
COPY Gemfile Gemfile.lock $APP_HOME/
RUN mkdir -p /opt/vendor/bundle \
 && chown -R app:app /opt \
 && su app -s /bin/bash -c "bundle install --path /opt/vendor/bundle"

# Copy application sources.
COPY --chown=app:app . $APP_HOME

# Switch to application user.
USER app

# Expose port 4567 to the Docker host, so we can access it from the outside.
EXPOSE 4567

# The main command to run when the container starts.
CMD ["bundle", "exec", "middleman", "server"]