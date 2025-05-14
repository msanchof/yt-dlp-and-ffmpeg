#!/bin/bash

# Comprobar si yt-dlp y ffmpeg están instalados, si no, instalarlos
command -v yt-dlp >/dev/null || {
  echo "yt-dlp no está instalado. Instalando..."
  sudo apt update
  sudo wget https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -O /usr/local/bin/yt-dlp
  sudo chmod +x /usr/local/bin/yt-dlp
}

command -v ffmpeg >/dev/null || {
  echo "ffmpeg no está instalado. Instalando..."
  sudo apt update
  sudo apt install -y ffmpeg
}

# Solicitar URL del video
read -p "Introduce la URL del vídeo de YouTube: " url

# Obtener y mostrar la lista de formatos disponibles
echo "Obteniendo formatos disponibles..."
yt-dlp -F "$url"

# Solicitar al usuario el format code de video
read -p "Elija el código del formato de video deseado (format code): " format_code

# Descargar el video con audio (combinado)
yt-dlp -f "${format_code}+bestaudio" "$url" -o "video_completo.%(ext)s"

# Extraer solo el audio a MP3
ffmpeg -i video_completo.mp4 -q:a 0 -map a audio_extraido.mp3

# Crear un video sin audio en formato comprimido
ffmpeg -i video_completo.mp4 -an -c:v libx265 -crf 28 video_sin_audio.mp4

# Mostrar información del video y del audio
echo "\nInformación del audio extraído:"
ffmpeg -i audio_extraido.mp3 2>&1 | grep -i "audio"

echo -"\nInformación del video sin audio:"
ffmpeg -i video_sin_audio.mp4 2>&1 | grep -i "video"
