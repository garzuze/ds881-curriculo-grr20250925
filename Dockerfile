FROM node:22-slim AS build

WORKDIR /app

COPY package.json ./

# Não usei o npm ci pois não tenho package-lock, estou usando o pnpm
RUN npm install

COPY src/input.css src/index.html ./src/

RUN npx @tailwindcss/cli -i ./src/input.css -o ./src/output.css


FROM nginxinc/nginx-unprivileged:alpine AS deploy

COPY --from=build /app/src /usr/share/nginx/html

USER nginx

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -qO- http://localhost:8080/ || exit 1

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]