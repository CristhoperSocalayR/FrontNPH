# Etapa 1: Compilación
FROM node:20-alpine AS builder

# Crear directorio de trabajo
WORKDIR /app

# Copiar archivos necesarios
COPY package*.json ./
COPY angular.json ./
COPY tsconfig*.json ./
COPY . .

# Instalar dependencias
RUN npm install

# Compilar la aplicación Angular (build clásica)
RUN npm run build

# Etapa 2: Imagen de producción (usando nginx para servir archivos estáticos)
FROM nginx:alpine

# Copiar el build al directorio de nginx
COPY --from=builder /app/dist/your-project-name /usr/share/nginx/html

# Copiar configuración personalizada de nginx (opcional)
# COPY nginx.conf /etc/nginx/nginx.conf

# Exponer el puerto por defecto de nginx
EXPOSE 80

# Comando por defecto de nginx
CMD ["nginx", "-g", "daemon off;"]
