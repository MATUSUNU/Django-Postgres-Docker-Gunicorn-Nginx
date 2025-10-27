#!/bin/sh

# For Dev Only

# If it’s set to "postgres", the script knows to wait for PostgreSQL before running migrations
# consider adding "DATABASE" in ".env.dev"
if [ "$DATABASE" = "postgres" ]
then
    echo "Waiting for postgres..."

    # Uses nc -z (netcat) to check if the DB host/port is accepting connections.
    while ! nc -z $SQL_HOST $SQL_PORT; do
      sleep 0.1
    done

    echo "PostgreSQL started"
fi

# python manage.py flush --no-input clears all data from the DB (dangerous in production!).
python manage.py flush --no-input
python manage.py migrate

# exec "$@" passes control to whatever command was given in the "Dockerfile" or "Compose" file
# (e.g. gunicorn, python manage.py runserver, etc.).
exec "$@"
