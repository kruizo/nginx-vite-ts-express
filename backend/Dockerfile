FROM node:18

WORKDIR /app

COPY package.json /app

COPY . /app

RUN npm install

EXPOSE 5000

CMD ["node", "server.js"]