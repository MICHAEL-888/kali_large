FROM kalilinux/kali-rolling:latest

WORKDIR /workspace

ENV DEBIAN_FRONTEND=noninteractive

RUN printf '%s\n' \
    'deb https://mirrors.tuna.tsinghua.edu.cn/kali kali-rolling main contrib non-free non-free-firmware' \
    > /etc/apt/sources.list

RUN printf '%s\n' \
    'Acquire::Retries "8";' \
    'Acquire::https::Timeout "30";' \
    'Acquire::http::Timeout "30";' \
    > /etc/apt/apt.conf.d/80-network-retry \
    && printf '%s\n' \
    'Acquire::https::Verify-Peer "false";' \
    'Acquire::https::Verify-Host "false";' \
    > /etc/apt/apt.conf.d/99-bootstrap-noverify \
    && apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates \
    && update-ca-certificates \
    && rm -f /etc/apt/apt.conf.d/99-bootstrap-noverify \
    && apt-get update \
    && apt-get install -y --no-install-recommends python3 python3-pip python3-venv kali-linux-large \
    && rm -rf /var/lib/apt/lists/*

RUN setcap cap_net_raw,cap_net_bind_service+eip /usr/lib/nmap/nmap

RUN curl -fsSL https://claude.ai/install.sh | bash
