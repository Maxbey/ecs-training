pipenv run uwsgi --module=application.app:app \
    --http-socket=0.0.0.0:8000 \
    --harakiri=90 \
    --http-timeout=90 \
    --max-requests=5000 \
    --vacuum \
    --post-buffering 1
