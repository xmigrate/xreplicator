FROM node:18-alpine AS builder

RUN apk add --no-cache libc6-compat

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build
RUN npm prune --omit=dev && npm cache clean --force

FROM node:18-alpine AS runner

RUN apk add --no-cache curl dumb-init

WORKDIR /app

COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/src/proto ./src/proto

RUN mkdir -p /app/.next/cache && chown -R node:node /app/.next /app/node_modules

USER node

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD curl -fsS http://127.0.0.1:3000/ || exit 1

ENTRYPOINT ["dumb-init", "--"]
CMD ["npm", "start"]
