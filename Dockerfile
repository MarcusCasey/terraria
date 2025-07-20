FROM ubuntu:22.04

RUN apt update && \
    apt install -y wget unzip lib32gcc-s1 screen libicu72 && \
    useradd -m terraria

USER terraria
WORKDIR /home/terraria

RUN wget https://dotnet.microsoft.com/download/dotnet/scripts/v1/dotnet-install.sh -O dotnet-install.sh && \
    chmod +x dotnet-install.sh && \
    ./dotnet-install.sh --runtime dotnet --version 8.0.0 --install-dir /home/terraria/dotnet

ENV PATH="/home/terraria/dotnet:$PATH"

RUN wget https://github.com/tModLoader/tModLoader/releases/download/v2025.05.3.0/tModLoader.zip && \
    unzip tModLoader.zip && \
    chmod +x ./start-tModLoaderServer.sh && \
    rm tModLoader.zip

RUN mkdir -p /home/terraria/.local/share/Terraria/ModLoader/Mods

COPY Mods/ /home/terraria/.local/share/Terraria/ModLoader/Mods/

EXPOSE 7777

CMD ["/home/terraria/dotnet/dotnet", "tModLoader.dll", "-server", "-ip", "0.0.0.0", "-port", "7777", "-players", "8", "-worldname", "GrindTime", "-world", "./GrindTime.wld", "-autocreate", "3", "-difficulty", "1", "-nosteam"]
