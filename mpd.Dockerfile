FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive
ENV MPD_VERSION=0.24.3

# ベース開発環境
RUN apt-get update && apt-get install -y \
    g++ \
    build-essential \
    python3 python3-pip \
    pkgconf ninja-build \
    curl wget git \
    meson \
    # MPD推奨依存ライブラリ
    libfmt-dev \
    libpcre2-dev \
    libmad0-dev libmpg123-dev libid3tag0-dev \
    libflac-dev libvorbis-dev libopus-dev libogg-dev \
    libadplug-dev libaudiofile-dev libsndfile1-dev libfaad-dev \
    libfluidsynth-dev libgme-dev libmikmod-dev libmodplug-dev \
    libmpcdec-dev libwavpack-dev libwildmidi-dev \
    libsidplay2-dev libsidutils-dev libresid-builder-dev \
    libavcodec-dev libavformat-dev \
    libmp3lame-dev libtwolame-dev libshine-dev \
    libsamplerate0-dev libsoxr-dev \
    libbz2-dev libcdio-paranoia-dev libiso9660-dev libmms-dev \
    libzzip-dev \
    libcurl4-gnutls-dev libexpat1-dev \
    nlohmann-json3-dev \
    libasound2-dev libao-dev libjack-jackd2-dev libopenal-dev \
    libpulse-dev libshout3-dev \
    libsndio-dev \
    libmpdclient-dev \
    libnfs-dev \
    libupnp-dev \
    libavahi-client-dev \
    libsqlite3-dev \
    libsystemd-dev \
    libgtest-dev \
    libicu-dev \
    libchromaprint-dev \
    libgcrypt20-dev \
    libpipewire-0.3-dev \
 && rm -rf /var/lib/apt/lists/*

# Meson最新版に更新
RUN python3 -m pip install --break-system-packages --upgrade pip meson

WORKDIR /build

RUN wget https://www.musicpd.org/download/mpd/0.24/mpd-${MPD_VERSION}.tar.xz && \
    tar -xf mpd-${MPD_VERSION}.tar.xz && \
    cd mpd-${MPD_VERSION} && \
    meson setup output/release --buildtype=debugoptimized -Db_ndebug=true -Dsysconfdir=/etc && \
    ninja -C output/release && \
    ninja -C output/release install

RUN mkdir -p /var/lib/mpd/music /var/lib/mpd/playlists /var/lib/mpd/database /run/mpd /etc/mpd

CMD ["mpd", "--no-daemon", "/etc/mpd/mpd.conf"]
