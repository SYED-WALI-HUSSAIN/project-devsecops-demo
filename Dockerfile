# Build stage
FROM alpine:latest AS build
WORKDIR /app
RUN apk update && apk upgrade --no-cache libexpat libxml2 libxslt   
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