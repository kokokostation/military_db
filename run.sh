#!/usr/bin/env bash

psql -f create_database.sql
psql -f create_tables.sql
psql -f create_triggers.sql
psql -f create_functions.sql
psql -f create_users.sql
psql -f prefill.sql

psql -f view_1.sql
psql -f view_2.sql
psql -f view_3.sql
psql -f view_4.sql
psql -f view_5.sql

psql -f use_views.sql

psql -f update_delete.sql
