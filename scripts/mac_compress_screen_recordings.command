#!/usr/bin/env bash

# This will take all *.mov files in ${HOME}/Desktop/screen_recordings_raw/,
# compress them and store them im ${HOME}/Desktop/screen_recordings_compressed/.

echo "Will make sure the environment is set up ..."

# maybe create input and output directories
echo "... ensuring all directories are present."
compressed_dir=${HOME}/Desktop/screen_recordings_compressed
source_dir=${HOME}/Desktop/screen_recordings_raw
export compressed_dir
mkdir -p "${compressed_dir}"/bin
mkdir -p "${source_dir}"

# maybe download ffmpeg
echo "... ensuring ffmpeg is present."
if [ ! -f "${compressed_dir}"/bin/ffmpeg ]; then
  curl https://evermeet.cx/ffmpeg/ffmpeg-4.2.2.zip \
    -o "${compressed_dir}"/bin/ffmpeg-4.2.2.zip
  cd "${compressed_dir}"/bin/ || exit
  unzip ffmpeg-4.2.2.zip
  chmod 755 ffmpeg
  cd - &>/dev/null || exit
fi

echo "... done setting up the environment."

# compress a video file if its compressed counter part is not already present
function maybe_compress_video {

  # construct file names and directories
  original_file="$*"
  just_file_name=$(basename "${original_file}")
  target_file_name=$(basename "${just_file_name}" .mov).mp4
  target_file="${compressed_dir}/${target_file_name}"

  # check if target already exists, return without further action if so
  [ -f "${target_file}" ] && { echo "... compressed file exists"; return; }

  # continue compressing if file does not exist
  echo "... converting ${just_file_name}"
  "${compressed_dir}"/bin/ffmpeg \
    -i "${original_file}" \
    -filter:v fps=fps=15 -c:v libx264 -crf 28 \
    "${target_file}"
  }
  export -f maybe_compress_video

# find all raw files and compress if needed
echo "Will find and compress all video files in ${source_dir} ..."
find \
  "${source_dir}" \
  -name \*\.mov \
  -print0 | \
  xargs -0 -n1 -P1 -I {} bash -c "maybe_compress_video {}"
echo "... done compressing all video files."
