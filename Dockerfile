# Stage 1: Build React Frontend
FROM node:17-alpine AS frontend-build
WORKDIR /app/client
COPY client/package*.json ./
RUN npm install --legacy-peer-deps
COPY client/ ./
RUN npm run build

# Stage 2: Setup Node.js Backend
FROM node:17-alpine AS backend
WORKDIR /app
COPY server/package*.json ./
RUN npm install
COPY server/ ./

# Stage 3: Final image with nginx serving frontend + node backend
FROM node:17-alpine
WORKDIR /app

# Install nginx
RUN apk add --no-cache nginx

# Copy backend
COPY --from=backend /app ./server

# Copy frontend build to nginx
COPY --from=frontend-build /app/client/build /usr/share/nginx/html

# Copy nginx config
COPY nginx.conf /etc/nginx/nginx.conf

# Copy startup script
COPY start.sh ./

RUN chmod +x start.sh

EXPOSE 80 5000

CMD ["./start.sh"]