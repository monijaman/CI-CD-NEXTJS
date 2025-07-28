FROM node:20-alpine

WORKDIR /app

# Install PM2 globally
RUN apk add --no-cache curl && \
    npm install --global pm2

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install  --legacy-peer-deps
# RUN npm ci --omit=dev
# Install production dependencies

# Copy application code
COPY . .

# Build the application.
RUN npm run build

# Change ownership to the non-root user (fixed to the correct path)
RUN chown -R node:node /app

# Expose the listening port
EXPOSE 3000

# Set NODE_ENV to production for production builds.
ENV NODE_ENV=production



# Launch app with PM2
CMD ["pm2-runtime", "start", "npm", "--", "run", "start"]
