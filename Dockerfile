FROM oven/bun:1

RUN apt-get update && apt-get install -y git curl && rm -rf /var/lib/apt/lists/*

RUN bun install -g github:garrytan/gbrain

WORKDIR /app
COPY start.sh .
RUN chmod +x start.sh

CMD ["./start.sh"]
