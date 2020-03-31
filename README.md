# Screencast Workflow

There's a more general [write-up about video recording of virtual conference talks and poster presentations here](https://willirath.github.io/blog/posts/2020-03-07-how-to-create-and-publish-videos-of-conference-contributions).


## Automated workflow on MacOSX

_This will set up an automated workflow that takes all files found in `Desktop/screen_recordings_raw/`, converts and compresses them, and puts them into `Desktop/screen_recordings_raw/`._

### Preparations _(only necessary once)_

Download [this file](https://raw.githubusercontent.com/willirath/screencast_workflow/master/scripts/mac_compress_screen_recordings.command) to your Desktop and make it executable.

To make the `mac_compress_screen_recordings.command` executable, open a Terminal (hit `Command(⌘)-Space` and type `terminal`) and run `chmod 755 ${HOME}/Desktop/mac_compress_screen_recordings.command`.

To set up the environment and run a test, execute `mac_compress_screen_recordings.command` by, e.g., double-clicking it or by chosing (secondary click) `open with -> Terminal`.
This will ensure
- there's a directory `Desktop/screen_recordings_compressed/` for the converted movies,
- there's a directory `Desktop/screen_recordings_raw/` for the original recordings, and that
- `ffmpeg` is available.

### Recording and compression

Use the screenshot tool (`Shift-Command(⌘)-5`) to record a video of your screen.
(See the [Apple support page](https://support.apple.com/en-us/HT208721) for details.)
Place the resulting video file in `screen_recordings_raw/` on your Desktop.

Then, execute the `mac_compress_screen_recordings.command`. (See above for how to do this.)
This will use `ffmpeg` to create a lower quality (but still great for online teaching) version of all `mov` files in `Desktop/screen_recordings_raw/` and place them in `Desktop/screen_recordings_compressed/`.

## What's happening under the hood?

The essentials are
```shell
ffmpeg -i "${original_file}" -vf fps=fps=15 -c:v libx264 -crf 28 "${target_file}"
```
with
- `-vf fps=fps=15` for reducing time resolution to 15 frames per second,
- `-c:v libx264` for selecting the codec,
- `-crf 28` for applying a constant rate factor (0 = very good, 51 = terrible), and
- `"${target_file}"` that should be named `...mp4` to make sure it plays in a web browser.
