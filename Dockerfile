FROM alpine:latest

LABEL maintainer="axiowse@gmail.com"

ENV PORT="443" \
    USER="Shadowsocksrr" \
    PASSWORD="shadowsocksrr" \
    METHOD="none" \
    PROTOCOL="auth_chain_a" \
    OBFS="tls1.2_ticket_auth"

RUN apk add libsodium python git

RUN git clone -b akkariiin/master https://github.com/axiowse/shadowsocksr.git /shadowsocksr \
    && cd /shadowsocksr \
    && chmod +x *.sh \
    && chmod +x shadowsocks/*.sh \
    && cp apiconfig.py userapiconfig.py \
    && cp config.json user-config.json \
    && cp mysql.json usermysql.json \
    && sed -i 's/sspanelv2/mudbjson/' userapiconfig.py \
    && python mujson_mgr.py -a -u ${USER} -p ${PORT} -k ${PASSWORD} -m ${METHOD} -O ${PROTOCOL} -o ${OBFS} -G "#"

WORKDIR /shadowsocksr

ENTRYPOINT ["python", "/shadowsocksr/server.py m>> ssserver.log 2>&1"]
