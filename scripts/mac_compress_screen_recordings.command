#!/usr/bin/env bash

# maybe create output directory
compressed_dir=${HOME}/Desktop/screen_recordings_compressed
export compressed_dir
mkdir -p ${compressed_dir}/bin

# maybe download ffmpeg
[ -f ${compressed_dir}/bin/ffmpeg ] || {
  curl https://evermeet.cx/ffmpeg/ffmpeg-4.2.2.zip -o "${compressed_dir}"/bin/ffmpeg-4.2.2.zip;
  cd "${compressed_dir}"/bin/;
  unzip ffmpeg-4.2.2.zip;
  chmod 755 ffmpeg
  cd -
}

function maybe_compress_video {

    # construct file names
    original_file="$@"
    just_file_name=$(basename "${original_file}")
    target_file="${compressed_dir}/compressed_${just_file_name}"

    # check if target already exists
    [ -f "${target_file}" ] && { echo "compressed file exists"; return; }

    # continue compressing if file does not exist
    echo Will convert ${just_file_name}
    "${compressed_dir}"/bin/ffmpeg \
        -i "${original_file}" \
        -filter:v fps=fps=20 -c:v libx264 -crf 28 \
        "${target_file}"
}
export -f maybe_compress_video

# find all files that need to be compressed and compress them
find \
    ${HOME}/Desktop/screen_recordings_raw/ \
    -name \*\.mov \
    -print0 | \
    xargs -0 -n1 -P1 -I {} bash -c "maybe_compress_video {}"
