# Base image (fixed LTS version)
FROM node:14.15.1-alpine as base

WORKDIR /app

# Dependencies
COPY package*.json ./
RUN npm install

# Build
WORKDIR /app
COPY . .
RUN npm run build

# Application
FROM node:14.15.1-alpine as application
COPY --from=base /app/package*.json ./
RUN npm install --only=production && npm cache clean --force
COPY --from=base /app/dist ./dist

USER node
ENV PORT=8080
EXPOSE 8080

CMD ["node", "dist/main.js"]
