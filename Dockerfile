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
RUN ln -s ~/.local/bin/claude /usr/local/bin/claude

RUN apt update
RUN apt install -y nuclei
RUN nuclei -ut

RUN wget https://github.com/shadow1ng/fscan/releases/download/1.8.4/fscan -O fscan
RUN chmod +x fscan
RUN mv fscan /usr/local/bin/

RUN wget https://github.com/nicocha30/ligolo-ng/releases/download/v0.8.3/ligolo-ng_agent_0.8.3_linux_amd64.tar.gz
RUN tar -xvf ligolo-ng_agent_0.8.3_linux_amd64.tar.gz
RUN chmod +x agent
RUN mv agent /usr/local/bin/ligolo-agent

RUN wget https://github.com/nicocha30/ligolo-ng/releases/download/v0.8.3/ligolo-ng_proxy_0.8.3_linux_amd64.tar.gz
RUN tar -xvf ligolo-ng_proxy_0.8.3_linux_amd64.tar.gz
RUN chmod +x proxy
RUN mv proxy /usr/local/bin/ligolo-proxy

RUN apt install --reinstall seclists

RUN apt install -y dirsearch

RUN apt install arjun -y

RUN go install -v github.com/projectdiscovery/interactsh/cmd/interactsh-client@latest \
    && cp /root/go/bin/interactsh-client /usr/local/bin/

RUN apt install xsstrike -y

RUN apt install tplmap -y

RUN apt install python3-pydash -y

RUN git clone https://github.com/tarunkant/Gopherus.git /opt/gopherus \
    && chmod +x /opt/gopherus/gopherus.py \
    && ln -s /opt/gopherus/gopherus.py /usr/local/bin/gopherus

CMD ["/bin/bash"]
