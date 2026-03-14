FROM node:18-alpine

LABEL maintainer="SSH Manager Chrome Extension"
LABEL description="WebSocket-to-SSH Bridge"

WORKDIR /app

# Dependencies zuerst (für besseres Layer-Caching)
COPY package.json .
RUN npm install --omit=dev && npm cache clean --force

# Server-Code
COPY server.js .

# Port der Bridge
EXPOSE 2222

# Nicht als root laufen
RUN addgroup -S bridge && adduser -S bridge -G bridge
USER bridge

CMD ["node", "server.js"]
