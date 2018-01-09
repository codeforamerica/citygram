#!/bin/bash

createdb -U postgres citygram_test
createdb -U postgres citygram_development

psql -U postgres citygram_test < /tmp/schema.sql
psql -U postgres citygram_development < /tmp/schema.sql