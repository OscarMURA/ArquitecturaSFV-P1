FROM node:18-alpine

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install --only=production

COPY . .

RUN chown -R node:node /usr/src/app

USER node

EXPOSE 8080

CMD ["npm", "start"]