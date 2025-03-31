# Use PostgreSQL 17 with Debian Bookworm as base
FROM postgres:17-bookworm

# Add any custom configurations or extensions if needed
# For example:
# COPY ./custom-postgresql.conf /etc/postgresql/postgresql.conf

# You can also install additional packages if required
RUN apt-get update && apt-get install -y \
     wget \
     && rm -rf /var/lib/apt/lists/*

# Copy initialization scripts
#COPY init-scripts/ /docker-entrypoint-initdb.d/

# Make sure scripts are executable
#RUN chmod +x /docker-entrypoint-initdb.d/*.sh

# The official image already sets up:
# - VOLUME /var/lib/postgresql/data
# - EXPOSE 5432
# - Required environment variables
# - Entrypoint script 