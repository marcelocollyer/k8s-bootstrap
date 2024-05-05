FROM node:21 AS builder

WORKDIR /app

COPY package*.json server.js ./

RUN npm install

FROM node:21-slim

WORKDIR /app

COPY --from=builder /app .

RUN apt update && \
    apt install -y curl

EXPOSE 3000

CMD ["node", "server.js"]