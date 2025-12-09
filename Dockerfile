ARG POSTGRES_VERSION=17
FROM postgres:${POSTGRES_VERSION}

# Install OpenSSL and sudo
RUN apt-get update
RUN apt-get install -y openssl
RUN apt-get install -y sudo
RUN apt-get install -y postgresql-17-cron

RUN echo "postgres ALL=(root) NOPASSWD: /usr/bin/mkdir, /bin/chown, /usr/bin/openssl" > /etc/sudoers.d/postgres

# Add init scripts while setting permissions
COPY --chmod=755 init-ssl.sh /docker-entrypoint-initdb.d/init-ssl.sh
COPY --chmod=755 wrapper.sh /usr/local/bin/wrapper.sh

RUN echo "shared_preload_libraries = 'pg_cron'" >> /usr/share/postgresql/postgresql.conf.sample
RUN echo "cron.database_name = 'railway'" >> /usr/share/postgresql/postgresql.conf.sample

ENTRYPOINT ["wrapper.sh"]
CMD ["postgres", "-p", "5432", "-c", "listen_addresses=*"]