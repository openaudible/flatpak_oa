FROM fedora:latest

RUN dnf update -y && \
    dnf install -y flatpak-builder flatpak git

RUN flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && \
    flatpak install -y flathub org.gnome.Platform//44 org.gnome.Sdk//44

WORKDIR /build

COPY build_flatpak.sh .
COPY org.openaudible.OpenAudible.yml .
COPY org.openaudible.OpenAudible.desktop .
COPY org.openaudible.OpenAudible.png .
COPY org.openaudible.OpenAudible.appdata.xml .

RUN chmod +x build_flatpak.sh

ENTRYPOINT ["./build_flatpak.sh"]
