#!/bin/sh

# Start Node.js backend in background
cd /app/server
node src/server.js &

# Start nginx in foreground
nginx -g 'daemon off;'
