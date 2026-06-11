FROM node:22-slim AS build

WORKDIR /app

COPY package.json ./


# Não usei o npm ci pois não tenho package-lock, estou usando o pnpm
RUN npm install

COPY src/input.css src/index.html ./src/

RUN npx @tailwindcss/cli -i ./src/input.css -o ./src/output.css

FROM nginx:alpine AS deploy

COPY --from=build /app/src /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]