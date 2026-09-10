FROM nginx:alpine
ARG VERSION=1.0.0
RUN echo "<h1>Web App Version ${VERSION}</h1>" > /usr/share/nginx/html/index.html
EXPOSE 80
