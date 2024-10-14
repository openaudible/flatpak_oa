FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && \
    apt-get install -y flatpak-builder flatpak git appstream appstream-util

RUN flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && \
    flatpak install -y flathub org.gnome.Platform//44 org.gnome.Sdk//44

WORKDIR /build

COPY *.sh .
COPY org.openaudible.OpenAudible.yml .
COPY org.openaudible.OpenAudible.desktop .
COPY org.openaudible.OpenAudible.png .
COPY org.openaudible.OpenAudible.appdata.xml .

RUN chmod +x *.sh
RUN ./test.sh

ENTRYPOINT ["./build_flatpak.sh"]
