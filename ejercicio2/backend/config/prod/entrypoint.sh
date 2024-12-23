#!/bin/sh

if [ "$DATABASE" = "postgres" ]
then
    echo "Waiting for postgres..."

    while ! nc -z $SQL_HOST $SQL_PORT; do
      sleep 0.1
    done

    echo "PostgreSQL started"
fi

# Uncomment below to flush db e.g. after running tests
# Just make sure you really mean it 
# python manage.py flush --no-input

# We have base custom user model so need to makemigrations out of box

echo "Making migrations ..."
python manage.py makemigrations core
python manage.py flush --no-input
python manage.py migrate

echo "Loading initial Data ..."
python manage.py loaddata initial_data.json

echo "Starting Gunicorn server..."
exec gunicorn core.wsgi:application --bind 0.0.0.0:8000 --workers=3 --threads=2 --access-logfile - --error-logfile -
