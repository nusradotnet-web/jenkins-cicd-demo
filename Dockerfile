FROM alpine:latest
RUN echo "Application successfully built via Jenkins!" > /app.txt
CMD ["cat", "/app.txt"]
