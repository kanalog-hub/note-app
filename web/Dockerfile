FROM node:18-alpine

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy application files
COPY . .

# Expose development port
EXPOSE 3000

CMD ["npm", "run", "dev"]
