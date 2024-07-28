# 使用官方Go镜像作为构建环境
FROM golang:1.22.2-alpine AS builder

# 设置工作目录
WORKDIR /app

# 安装构建依赖
RUN apk add --no-cache gcc musl-dev

# 复制go mod和sum文件
COPY go.mod go.sum ./

# 下载依赖
RUN go mod download

# 复制源代码
COPY . .

# 构建应用
RUN CGO_ENABLED=1 GOOS=linux go build -a -installsuffix cgo -o zns ./cmd/zns

# 使用Alpine作为运行环境
FROM alpine:latest

# 安装必要的系统依赖
RUN apk --no-cache add ca-certificates tzdata sqlite

# 设置工作目录
WORKDIR /root/

# 从构建阶段复制二进制文件
COPY --from=builder /app/zns .

# 复制静态文件（如果有的话）
COPY web ./web

# 创建数据目录
RUN mkdir -p /data

# 暴露端口
EXPOSE 443

# 运行应用
<<<<<<< HEAD
CMD ["./zns", "-db", "/data/zns.db", "-root", "./web"]
=======
CMD ["./zns", "-db", "/data/zns.db", "-root", "./web"]
>>>>>>> ded3956cdf27b1c3def1d513716d5d9856a23891
