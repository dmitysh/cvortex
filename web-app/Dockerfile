FROM node:20-alpine AS builder

WORKDIR /app
COPY package.json ./
RUN npm install --silent
COPY . .

ARG VITE_BACKEND_BASE_URL
ARG VITE_TG_URL
ENV VITE_BACKEND_BASE_URL=${VITE_BACKEND_BASE_URL}
ENV VITE_TG_URL=${VITE_TG_URL}

RUN npm run build


FROM nginx:alpine
WORKDIR /usr/share/nginx/html
RUN rm -rf ./*
COPY --from=builder /app/dist .
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
