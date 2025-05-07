# Etapa 1: Compilación
FROM node:20-alpine AS builder

# Crear directorio de trabajo
WORKDIR /app

# Copiar archivos necesarios
COPY package*.json ./
COPY tsconfig.* ./
COPY angular.json ./
COPY . .

# Instalar dependencias
RUN npm install

# Compilar la aplicación Angular con SSR
RUN npm run build:ssr

# Etapa 2: Imagen de producción
FROM node:20-alpine

# Crear directorio de trabajo
WORKDIR /app

# Copiar desde la etapa de build
COPY --from=builder /app/dist /app/dist
COPY --from=builder /app/node_modules /app/node_modules
COPY --from=builder /app/package.json /app/package.json

# Exponer el puerto en el que se ejecutará el servidor (ajusta si usas otro)
EXPOSE 4000

# Comando de inicio para producción SSR
CMD ["node", "dist/nph-dashboard/server/server.mjs"]
