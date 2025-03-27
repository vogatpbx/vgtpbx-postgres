#!/bin/bash
set -e

# Create FreeSWITCH user and database
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    -- Create FreeSWITCH user
    CREATE USER freeswitch WITH PASSWORD '$SWITCH_DB_PASSWORD';

    -- Create FreeSWITCH database
    CREATE DATABASE freeswitch OWNER freeswitch;

    -- Connect to FreeSWITCH database
    \c freeswitch

    -- Grant privileges
    GRANT ALL PRIVILEGES ON DATABASE freeswitch TO freeswitch;
    GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO freeswitch;
    GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO freeswitch;
EOSQL 