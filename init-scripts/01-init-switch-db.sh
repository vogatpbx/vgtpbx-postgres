#!/bin/bash
set -e

# Set default password if not provided
database_password=${DATABASE_PASSWORD:-insecure12345}

# Create directory structure and download schema
mkdir -p /var/lib/postgresql/switch/resources/templates/sql/
wget -O /var/lib/postgresql/switch/resources/templates/sql/switch.sql https://raw.githubusercontent.com/kayp514/VogatPBX-AdminUI/main/switch/resources/templates/sql/switch.sql

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<EOSQL
    -- Create FreeSWITCH database
    CREATE DATABASE freeswitch;

    -- Create FreeSWITCH role with superuser privileges
    CREATE ROLE freeswitch WITH SUPERUSER LOGIN PASSWORD '$database_password';

    -- Grant privileges
    GRANT ALL PRIVILEGES ON DATABASE freeswitch TO freeswitch;

    -- Connect to freeswitch database
    \c freeswitch

    -- Create uuid-ossp extension
    CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

    -- Create schema for FreeSWITCH
    CREATE SCHEMA IF NOT EXISTS freeswitch;

    -- Grant schema privileges to freeswitch role
    GRANT ALL ON SCHEMA freeswitch TO freeswitch;

    -- Set search path
    ALTER DATABASE freeswitch SET search_path TO freeswitch,public;

    -- Set schema owner
    ALTER SCHEMA freeswitch OWNER TO freeswitch;
EOSQL

# Apply the FreeSWITCH schema
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "freeswitch" -f /var/lib/postgresql/switch/resources/templates/sql/switch.sql