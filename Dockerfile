FROM ruby:2.7.1-slim


ENV LC_ALL=C.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

RUN apt-get update && apt-get install curl wget gnupg2 -y && \
    rm -rf /var/lib/apt/lists/*

# Add Node
# If your app is api, this is unnecessary
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get -y install nodejs

# Add yarn
# If your app is api, this is unnecessary
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install yarn && \
    rm -rf /var/lib/apt/lists/*

# Add Pqsl
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main" > /etc/apt/sources.list.d/pgdg.list

RUN apt-get update && apt-get install postgresql-client-12 build-essential \
    bc imagemagick libcurl4-openssl-dev libpq-dev iproute2 openssh-server git -y && \
    rm -rf /var/lib/apt/lists/*

RUN gem install bundler

RUN mkdir /project_name
WORKDIR /project_name

ENTRYPOINT ["./docker-entrypoint.sh"]
