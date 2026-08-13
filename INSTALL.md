# Installation

To compile, type:

```bash
./bootstrap
./configure
make
```

Then to install, type:

```bash
make install
```

If you do not want the files installed to `/usr/local/bin`, specify a different prefix when running `configure`:

```bash
./configure --prefix=/usr
```

or any other directory.

## Useful `configure` options

These options may be used to restore behavior that was built into older versions of DVDAuthor.

```bash
./configure --enable-default-video-format=NTSC
./configure --enable-default-video-format=PAL
```

Without one of these, there is no hard-coded default video format. Of course, a user- or system-specified default always takes precedence if present.

```bash
./configure --enable-localize-filenames
```

Specify this if you want filenames to be interpreted according to your locale setting. Without this, filenames are assumed to be in UTF-8 encoding.
