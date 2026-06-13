#step 1. Build the linux binary
FROM ubuntu:22.04 AS builder
RUN apt-get update && apt-get install -y cmake g++ make

WORKDIR /app
COPY . .
RUN mkdir build && cd build && cmake .. && make

#Step 2. Minimal runtime image
FROM ubuntu:22.04
WORKDIR /root/
COPY --from=builder /cppapp/build/hello .
CMD ["./hello"]

