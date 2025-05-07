# Etapa 1: Construcción de la app
FROM node:20-alpine AS builder

# Establece el directorio de trabajo
WORKDIR /app

# Copia los archivos necesarios
COPY package.json package-lock.json ./
RUN npm ci

COPY . .

# Compila la aplicación Angular
RUN npm run build --prod

# Etapa 2: Imagen ligera de producción con nginx
FROM nginx:alpine

# Elimina la configuración por defecto de nginx
RUN rm -rf /usr/share/nginx/html/*

# Copia los archivos generados de la compilación al contenedor de nginx
COPY --from=builder /app/dist/* /usr/share/nginx/html/

# Copia una configuración personalizada de nginx (opcional)
# COPY nginx.conf /etc/nginx/nginx.conf

# Expone el puerto 80
EXPOSE 80

# Comando por defecto
CMD ["nginx", "-g", "daemon off;"]
