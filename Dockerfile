# Stage 1 — Build the Next.js app
FROM node:20-alpine AS builder
WORKDIR /app

# Copy package files and install dependencies
COPY my-nextjs-app/package*.json ./
RUN npm install

# Copy the rest of the app and build
COPY my-nextjs-app/ ./
RUN npm run build

# Stage 2 — Run the app in production
FROM node:20-alpine
WORKDIR /app

# Copy only what’s needed from builder
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/node_modules ./node_modules

EXPOSE 7000
CMD ["npm", "start"]
