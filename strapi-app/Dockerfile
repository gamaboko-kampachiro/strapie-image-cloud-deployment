FROM node:18-alpine

WORKDIR /app

# Install system dependencies required by Strapi
RUN apk add --no-cache \
  python3 \
  make \
  g++ \
  vips-dev \
  cairo-dev \
  pango-dev \
  libjpeg-turbo-dev \
  giflib-dev

# Install Node dependencies
COPY package*.json ./
RUN npm install

# Copy app source
COPY . .

# Build Strapi admin
RUN npm run build

EXPOSE 1337

CMD ["npm", "run", "start"]
