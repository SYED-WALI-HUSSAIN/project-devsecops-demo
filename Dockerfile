# Build stage
FROM node:20-alpine AS build
WORKDIR /app
RUN apk update && \
    apk upgrade --no-cache && \
    apk add --no-cache \
        libexpat=2.7.0-r0 \
        libxml2=2.13.4-r5 \
        libxslt=1.1.42-r2
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Production stage
FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
# Add nginx configuration if needed
# COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]