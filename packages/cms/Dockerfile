# Development stage
# FROM --platform=linux/amd64 oky/base as development
FROM oky/base as development

ENV NODE_ENV=development
ENV GOOGLE_APPLICATION_CREDENTIALS=/usr/src/app/packages/cms/firebase-config.json
WORKDIR /usr/src/app/packages/cms

CMD [ "yarn", "run", "start" ]

# Production stage
# FROM --platform=linux/amd64 node:16.13.1 as production
FROM node:16.13.1 as production

ENV NODE_ENV=production
WORKDIR /usr/src/app

COPY --from=oky/base /usr/src/app/node_modules ./node_modules
COPY --from=oky/base /usr/src/app/packages/cms/package.json .
COPY --from=oky/base /usr/src/app/packages/cms/dist ./dist

# Add these missing lines to include the @oky/core package
COPY --from=oky/base /usr/src/app/packages/core/package.json ./packages/core/package.json
COPY --from=oky/base /usr/src/app/packages/core/dist ./packages/core/dist
# Add the source translations directory
COPY --from=oky/base /usr/src/app/packages/core/src ./packages/core/src

CMD [ "yarn", "serve" ]
