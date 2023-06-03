# source os

FROM debian:11

# http://bugs.python.org/issue19846

# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.

ENV LANG=C.UTF-8 \

    DEBCONF_NONINTERACTIVE_SEEN=true \

    DEBIAN_FRONTEND=noninteractive \

    PIP_NO_CACHE_DIR=1 \

    SHELL=/bin/bash

# install necessary packages

RUN apt update; \

    apt upgrade -y; \

    apt install -y --no-install-recommends \

    ca-certificates git netbase tzdata wget gcc \

    python3.9 apt-utils bash gnupg dirmngr

# install some less important packages and clear apt cache db

RUN apt install -y --no-install-recommends \

    mediainfo wkhtmltopdf iputils-ping \

    p7zip-full zip unzip cowsay make pdftk \

    sudo pkg-config neofetch tree locate \

    megatools curl procps qbittorrent-nox libmagic-dev aria2 ffmpeg man git \

    python3-pip python3.9-venv python3-lib2to3

# Setup User and Venv

ENV USR=dot

RUN useradd -m -u 1000 $USR

USER $USR

ENV HOME /home/$USR

ENV VIRTUAL_ENV $HOME/.venv

RUN python3 -m venv $VIRTUAL_ENV

ENV TEMP $HOME/temp

ENV PATH $VIRTUAL_ENV/bin:/usr/local/bin:$PATH

# install rar package

RUN mkdir -p $TEMP; cd $TEMP; \

    wget -q -O rarlinux.tar.gz "http://www.rarlab.com/rar/rarlinux-x64-620.tar.gz"; \

    tar -xzvf rarlinux.tar.gz && cp -v rar/rar rar/unrar /usr/local/bin/; \

    \

    rm -rf "rar*" "/var/lib/apt/lists/*"

# copy requirements file

COPY requirements.txt $TEMP

# update pip, wheel, setuptools and install all pip requirements.

RUN python3 -m pip install -U pip setuptools wheel; \

    python3 -m pip install -r $TEMP/requirements.txt; \

    rm -rvf "$TEMP/*"

# clone repo and set working directory

RUN git clone "https://github.com/itzrexmodz/mirror-leech-telegram-bot" $HOME/app

WORKDIR $HOME/app

# expose port

EXPOSE 7860

# Startup

COPY web.py .

CMD [ "gunicorn", "-b", "0.0.0.0:7860", "-w", "1", "web:app" ]
