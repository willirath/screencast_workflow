# Screencast Workflow

There's a more general [write-up about video recording of virtual conference talks and poster presentations here](https://willirath.github.io/blog/posts/2020-03-07-how-to-create-and-publish-videos-of-conference-contributions).


## Workflow on MacOSX

Download [this file](https://raw.githubusercontent.com/willirath/screencast_workflow/master/scripts/mac_compress_screen_recordings.command) to your Desktop and make it executable (see below for how that works).

On a Mac, use the screenshot tool (`Shift-Command(⌘)-5`) to record a video of your screen.
Place it in a directory called `screen_recordings_raw` on your Desktop.

Then, run the `mac_compress_screen_recordings.command`, e.g., by double-clicking it.
This will ensure there's a directory `screen_recordings_compressed` on your Desktop, download `ffmpeg` if necessary and use `ffmpeg` to create a lower quality (but still great for online teaching) version of your screen recording and place it in `screen_recordings_compressed/`.

On a 2019 MacBook Pro 13", the compressed screen recordings are approx. 130MB / hour.
