# Step 1: Use the official Node.js image as the base image
FROM node:14

# Step 2: Set the working directory inside the container
WORKDIR /usr/src/app

# Step 3: Copy package.json and package-lock.json
COPY package*.json ./

# Step 4: Install dependencies
RUN npm install

# Step 5: Copy the rest of your application code
COPY . .

# Step 6: Expose the port your app will run on
EXPOSE 1339

# Step 7: Start the application
CMD ["node", "index.js"]
