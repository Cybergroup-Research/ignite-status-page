FROM heroku/heroku:18

ENV NODE_ENGINE 12.18.1

ENV PATH /app/heroku/node/bin/:$PATH

ARG build_tag

RUN mkdir -p /app/heroku/node /app/.profile.d

# Install node
RUN curl -s https://s3pository.heroku.com/node/v$NODE_ENGINE/node-v$NODE_ENGINE-linux-x64.tar.gz | tar --strip-components=1 -xz -C /app/heroku/node

RUN mkdir -p /usr/src/nodered

WORKDIR /usr/src/nodered

# copy everything
COPY ./package.json ./
COPY ./Gruntfile.js ./
COPY ./Procfile ./
COPY ./ofc.js ./
COPY ./build.sh ./
COPY ./packages ./packages/
COPY ./scripts ./scripts/

RUN chmod +rwx ./build.sh

RUN ./build.sh ${build_tag}

RUN rm -rf ./packages/node_modules/@node-red/editor-client/src

CMD ["npm", "start"]