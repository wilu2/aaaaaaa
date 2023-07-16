FROM registry.intsig.net/base/openresty:1.17.8.2-ubuntu20.04

RUN luarocks install busted && \
    luarocks install lua-resty-http && \
    luarocks install ljsonschema && \
    luarocks install lua-resty-jit-uuid && \
    luarocks --server=http://rocks.moonscript.org install lyaml

ADD busted /usr/local/openresty/luajit/bin/busted
RUN chmod +x /usr/local/openresty/luajit/bin/busted
#RUN apt install iputils-ping
#apt-get install vim

COPY /conf/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
COPY /lua/ /usr/local/openresty/nginx/lua/

# 将测试代码文件添加到容器
ADD test.lua /app/test.lua
ADD thing_module.lua /app/thing_module.lua

ADD test.lua /usr/local/openresty/lualib/
ADD thing_module.lua /usr/local/openresty/lualib/


# 设置工作目录
WORKDIR /app
