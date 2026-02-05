#!/bin/bash
yum update -y

# Install Docker
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker

# Run Strapi from Docker Hub
docker run -d \
  -p 1337:1337 \
  -e NODE_ENV=production \
  -e ADMIN_JWT_SECRET=prod_admin_secret \
  -e JWT_SECRET=prod_jwt_secret \
  -e API_TOKEN_SALT=prod_token_salt \
  -e APP_KEYS=key1,key2,key3,key4 \
  manishkjain/strapi:latest
