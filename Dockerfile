FROM scratch

WORKDIR /

COPY ./ropoly /

EXPOSE 8008

ENTRYPOINT ["/ropoly"]
