FROM alpine:edge
WORKDIR /app
RUN apk --update --no-cache add make gcc g++ musl-dev binutils autoconf automake libtool pkgconfig check-dev file patch bash git ncurses-dev parted-dev clang-dev linux-headers
RUN git clone --branch v0.34 https://github.com/martijnvanbrummelen/nwipe.git
WORKDIR /app/nwipe
RUN sh ./autogen.sh
RUN ./configure
RUN make
RUN make install
CMD ["tail", "-f", "/dev/null"]