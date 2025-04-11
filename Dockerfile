# 第一阶段：克隆代码
#FROM alpine:latest AS git-clone
#WORKDIR /app
#
## 更换国内镜像源（阿里云）
#RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
#
## 安装 git（带缓存优化）
#RUN apk add --no-cache git
#
#RUN git config --global user.name 'hanchaoqi'
#RUN git config --global user.email '10890947+hanchaoqi@user.noreply.gitee.com'
#
#RUN git clone https://gitee.com/hanchaoqi/miniprogress.git .

# 第二阶段：编译代码
FROM golang:1.21 AS builder
WORKDIR /build

ENV GOPROXY=https://goproxy.cn,direct
ENV GOSUMDB=sum.golang.org

RUN go mod tidy

RUN CGO_ENABLED=0 GOOS=linux go build -o app-server

# 第三阶段：运行时镜像
FROM alpine:latest
WORKDIR /runtime
COPY --from=builder /build/app-server .
CMD ["/runtime/app-server"]