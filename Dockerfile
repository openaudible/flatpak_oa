FROM flatpak/flatpak-builder:base
ENV DEBIAN_FRONTEND=noninteractive

RUN dnf upgrade -y

WORKDIR /build

COPY *.sh .
COPY org.openaudible.OpenAudible.yml .
COPY org.openaudible.OpenAudible.desktop .
COPY org.openaudible.OpenAudible.png .
COPY org.openaudible.OpenAudible.appdata.xml .

RUN chmod +x *.sh
# RUN ./test.sh

# ENTRYPOINT ["./build_flatpak.sh"]
ENTRYPOINT ["bash"]

