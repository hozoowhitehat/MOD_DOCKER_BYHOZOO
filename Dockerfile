# Gunakan Debian sebagai basis
FROM dorowu/ubuntu-desktop-lxde-vnc

# Install aplikasi dan alat tambahan
RUN apt update && apt install -y \
    gnome-games \
    gdebi \
    gedit \
    gimp \
    inkscape \
    kdenlive \
    krita \
    lollypop \
    obs-studio \
    thunderbird \
    vim \
    pulseaudio \
    pavucontrol \
    papirus-icon-theme \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Unduh dan jalankan skrip perbaikan
RUN wget https://raw.githubusercontent.com/wahasa/Ubuntu/main/Apps/firefoxfix.sh && \
    chmod +x firefoxfix.sh && ./firefoxfix.sh && rm firefoxfix.sh

RUN wget https://raw.githubusercontent.com/wahasa/Ubuntu/main/Apps/libreofficefix.sh && \
    chmod +x libreofficefix.sh && ./libreofficefix.sh && rm libreofficefix.sh

RUN wget https://raw.githubusercontent.com/wahasa/Ubuntu/main/Apps/vscodefix.sh && \
    chmod +x vscodefix.sh && ./vscodefix.sh && rm vscodefix.sh

# Unduh wallpaper anime
RUN wget -O /usr/share/backgrounds/anime-wallpaper.jpg \
    https://c4.wallpaperflare.com/wallpaper/702/677/218/anime-anime-girls-sword-red-fan-art-hd-wallpaper-preview.jpg

# Set wallpaper sebagai default
RUN echo '[greeter]' > /etc/xdg/lxsession/LXDE/autostart && \
    echo '@pcmanfm --set-wallpaper /usr/share/backgrounds/anime-wallpaper.jpg' >> /etc/xdg/lxsession/LXDE/autostart

# Gunakan ikon Papirus agar mirip Windows 10
RUN mkdir -p ~/.icons && ln -s /usr/share/icons/Papirus ~/.icons/Papirus

# Konfigurasi suara
ENV PULSE_SERVER=unix:/tmp/pulseaudio.socket
VOLUME [ "/tmp/.X11-unix", "/run/user/1000/pulse" ]

# Ekspos port NoVNC
EXPOSE 6980

# Jalankan desktop saat container dimulai
CMD ["/usr/bin/supervisord"]
