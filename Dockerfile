FROM scottyhardy/docker-wine:latest

WORKDIR /app
COPY . /app

RUN apt-get update && apt-get install -y jq && rm -rf /var/lib/apt/lists/*

EXPOSE 8080/tcp
EXPOSE 8045/tcp
EXPOSE 3074/tcp
EXPOSE 6542/tcp
EXPOSE 3074/udp

RUN cat << 'EOF' > /app/entrypoint.sh
#!/bin/bash
set -e
export WINEDEBUG=-all

if [ -n "$ADMIN_PORT" ]; then
  echo "➡️ Configuring Admin Panel on port $ADMIN_PORT"
  jq --argjson port "$ADMIN_PORT" '.Adminpanel.port = $port' server-config.json > server-config.tmp && mv server-config.tmp server-config.json
else
  echo "ℹ️ ADMIN_PORT not set, using default port (8045)"
fi

exec wine server.exe
EOF

RUN sed -i 's/\r$//' /app/entrypoint.sh && chmod +x /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]
