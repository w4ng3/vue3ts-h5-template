# 安装Node.js，若要指定版本则 node:18.17.0
FROM node:latest

# 创建工作目录
WORKDIR /app

# 将node_modules添加到工作目录
COPY package.json .
RUN npm config set registry https://registry.npmmirror.com
RUN npm install
RUN echo "依赖安装完成..."

# 将所有文件复制到工作目录
COPY . .

# 编译前端项目
RUN echo '开始build'
# RUN pnpm run build
RUN npm run build
RUN echo '---build 完成---'

# 指定基础镜像为最新版 nginx
FROM nginx:latest
RUN echo '拷贝dist到 nginx目录'
COPY  /app/dist /usr/share/nginx/html/
COPY  /app/nginx.conf /etc/nginx/conf.d/default.conf

# 构建镜像: docker build -t vue3ts-h5 .
# 启动：docker run -itd -p 8001:80 --name vue3ts-h5 vue3ts-h5