# ---------- Build stage ----------
FROM node:20-alpine AS build
WORKDIR /app

COPY frontend/package*.json ./
RUN npm ci

# ARG VITE_API_BASE
# ENV VITE_API_BASE=${VITE_API_BASE}

COPY frontend/. .
RUN npm run build

# ---------- Runtime stage ----------
FROM nginx:alpine AS runtime
WORKDIR /usr/share/nginx/html

COPY --from=build /app/dist ./
COPY frontend/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]



