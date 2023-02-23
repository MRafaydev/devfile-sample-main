# Install the app dependencies in a full Node docker image
FROM registry.access.redhat.com/ubi8/nodejs-16:latest

# Copy package.json and package-lock.json
COPY package*.json ./

# Install app dependencies
RUN npm ci

# Copy the dependencies into a Slim Node docker image
FROM registry.access.redhat.com/ubi8/nodejs-16-minimal:latest

# Copy the rest of the application code into the image
COPY . /opt/app-root/src

# Copy the installed dependencies from the previous image
COPY --from=0 /opt/app-root/src/node_modules /opt/app-root/src/node_modules

# Set environment variables
ENV NODE_ENV production
ENV PORT 3001

# Set the command to run the application
CMD ["npm", "start"]