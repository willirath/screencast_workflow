#!/usr/bin/env bash

# This will take all *.mov files in ${HOME}/Desktop/screen_recordings_raw/,
# compress them and store them in ${HOME}/Desktop/screen_recordings_compressed/.

set -eu

echo "Will make sure the environment is set up ..."

# maybe create input and output directories
echo "... ensuring all directories are present."
compressed_dir=${HOME}/Desktop/screen_recordings_compressed
source_dir=${HOME}/Desktop/screen_recordings_raw
mkdir -p "${compressed_dir}"/bin
mkdir -p "${source_dir}"

# pick a static ffmpeg build matching the host architecture
# (martin-riedl.de provides current notarized builds for both arm64 and amd64)
arch=$(uname -m)
case "${arch}" in
  arm64)
    ffmpeg_url="https://ffmpeg.martin-riedl.de/redirect/latest/macos/arm64/release/ffmpeg.zip"
    ;;
  x86_64)
    ffmpeg_url="https://ffmpeg.martin-riedl.de/redirect/latest/macos/amd64/release/ffmpeg.zip"
    ;;
  *)
    echo "Unsupported architecture: ${arch}" >&2
    exit 1
    ;;
esac

# prefer an ffmpeg already on PATH (e.g. Homebrew); otherwise download into bin/
ffmpeg_bin=""
if command -v ffmpeg >/dev/null 2>&1; then
  ffmpeg_bin=$(command -v ffmpeg)
  echo "... using existing ffmpeg at ${ffmpeg_bin}."
elif [ -x "${compressed_dir}/bin/ffmpeg" ]; then
  ffmpeg_bin="${compressed_dir}/bin/ffmpeg"
  echo "... using previously downloaded ffmpeg at ${ffmpeg_bin}."
else
  echo "... downloading ffmpeg for ${arch} from ${ffmpeg_url}."
  curl -L "${ffmpeg_url}" -o "${compressed_dir}/bin/ffmpeg.zip"
  unzip -o "${compressed_dir}/bin/ffmpeg.zip" -d "${compressed_dir}/bin/"
  rm "${compressed_dir}/bin/ffmpeg.zip"
  chmod 755 "${compressed_dir}/bin/ffmpeg"
  # downloaded binaries are quarantined by Gatekeeper; remove the attribute so
  # the script can run unattended without a security prompt
  xattr -d com.apple.quarantine "${compressed_dir}/bin/ffmpeg" 2>/dev/null || true
  ffmpeg_bin="${compressed_dir}/bin/ffmpeg"
fi

echo "... done setting up the environment."

# compress a video file if its compressed counterpart is not already present
maybe_compress_video() {
  original_file="$1"
  just_file_name=$(basename "${original_file}")
  target_file_name=$(basename "${just_file_name}" .mov).mp4
  target_file="${compressed_dir}/${target_file_name}"

  if [ -f "${target_file}" ]; then
    echo "... compressed file exists: ${target_file_name}"
    return
  fi

  echo "... converting ${just_file_name}"
  "${ffmpeg_bin}" \
    -i "${original_file}" \
    -filter:v fps=fps=15 -c:v libx264 -crf 28 \
    "${target_file}"
}

# find all raw files and compress if needed
echo "Will find and compress all video files in ${source_dir} ..."
shopt -s nullglob
for f in "${source_dir}"/*.mov; do
  maybe_compress_video "${f}"
done
echo "... done compressing all video files."
