# dvdauthor

`dvdauthor` is a program that generates a DVD-Video movie from a valid MPEG-2 stream so it will play when inserted into a DVD player.

To start, you need MPEG-2 files that contain the necessary DVD-Video VOB packets. These can be generated with FFmpeg, or by passing `-f 8` to `mplex`.

## Quickstart

### Build and install

```bash
./bootstrap
./configure
make
make install
```

If you do not want to install into `/usr/local/bin`, pass a custom prefix to `configure`:

```bash
./configure --prefix=/usr
make
make install
```

### Build on Windows

You can build dvdauthor on Windows using MSYS2, which provides a Unix-like environment with MinGW toolchain:

1. Install [MSYS2](https://www.msys2.org/) if you haven't already
2. Open MSYS2 MINGW64 terminal
3. Install build dependencies:

```bash
pacman -S base-devel autoconf autoconf2.72 automake libtool gettext gettext-devel \
  mingw-w64-x86_64-toolchain mingw-w64-x86_64-gettext mingw-w64-x86_64-pkgconf \
  mingw-w64-x86_64-libdvdread mingw-w64-x86_64-libpng mingw-w64-x86_64-libxml2 \
  mingw-w64-x86_64-fontconfig mingw-w64-x86_64-freetype mingw-w64-x86_64-fribidi
```

4. Build dvdauthor:

```bash
./bootstrap
WANT_AUTOCONF=2.72 WANT_AUTOMAKE=1.16 autoreconf -fiv
./configure --prefix=/mingw64/local
make
make install
```

Alternatively, you can download pre-built Windows binaries from the [releases page](https://github.com/prinsbert/dvdauthor/releases).

### Build with Nix

Two Nix package definitions are provided:

- **`nix/nixos-26.05.nix`** The canonical [nixos-26.05](https://github.com/NixOS/nixpkgs/blob/nixos-26.05/pkgs/by-name/dv/dvdauthor/package.nix) derivation from [SourceForge](https://sourceforge.net/projects/dvdauthor/files/) with patches applied from [upstream](https://github.com/ldo/dvdauthor).
- **`nix/package.nix`** A local repository variant that builds from this source tree

#### Using nix/package.nix (from local repository)

To build directly from this repository:

```bash
nix build --impure --expr '(import <nixpkgs> {}).callPackage ./nix/package.nix {}'
```

The result will be symlinked as `result/` in the current directory, containing the built dvdauthor binaries.

#### Installing the Nix build

To install the built package into your Nix profile:

```bash
nix profile install --impure --expr '(import <nixpkgs> {}).callPackage ./nix/package.nix {}'
```

### Basic workflow

1. Delete a previously authored DVD:

   ```bash
   dvddirdel [-o dir]
   ```

2. Create your titlesets:

   ```bash
   dvdauthor [-o dir] [audio/video/subpicture options] [chapters]
   ```

   For a single chapter per MPEG file, you can do:

   ```bash
   dvdauthor -o dvd chap1.mpg chap2.mpg chap3.mpg
   ```

   To manually specify chapters:

   ```bash
   dvdauthor -o dvd -c chap1a.mpg chap1b.mpg -c chap2a.mpg chap2b.mpg
   ```

3. Create the table of contents:

   ```bash
   dvdauthor -T -o dvd
   ```

After that, you have a DVD-Video directory structure on disk that should work. You can then write it to a DVD, mini-DVD (CD), or play it directly from the HDD. To generate the UDF image used for burning to DVD, use `mkisofs` with the `-dvd-video` option.

**Note for Windows users:** On Windows, run commands with the `.exe` extension (e.g., `dvdauthor.exe` instead of `dvdauthor`), or ensure the installation directory is added to your system `Path` environment variable to run commands without the extension.

## How to Use

There are 3 steps to building the DVD directory structure on your HDD.

### 1. Delete a previously authored DVD

```bash
dvddirdel [-o dir]
```

To guard against mistakes, this only deletes files and subdirectories that look like part of a DVD-Video structure.

### 2. Create your titlesets

```bash
dvdauthor [-o dir] [audio/video/subpicture options] [chapters]
```

To create 1 chapter per MPEG file, simply do:

```bash
dvdauthor [-o dir] [a/v/s options] chap1.mpg chap2.mpg chap3.mpg...
```

To manually specify chapters, use the `--chapters` option:

```bash
dvdauthor [-o dir] [a/v/s options] -c chap1a.mpg chap1b.mpg -c chap2a.mpg chap2b.mpg ....
```

To add chapters every fifteen minutes, do:

```bash
dvdauthor [-o dir] [a/v/s options] -c 0,15:00,30:00,45:00,1:00:00,1:15:00... longvideo.mpg
```

Call `dvdauthor` for each titleset you want to create. Due to the DVD-Video standard, all audio, video, and subpicture options must be set once for the entire titleset; i.e. you cannot mix PAL and NTSC video in the same titleset. For that, generate separate titlesets.

Run `dvdauthor -h` to see the audio, video, and subpicture options. Note that `dvdauthor` can auto-detect most parameters except the language.

### 3. Create the table of contents

```bash
dvdauthor -T [-o dir]
```

## Example

**Linux/macOS:**
```bash
./bootstrap
./configure --prefix=/usr/local
make
sudo make install

# Create a DVD structure from an MPEG-2 source
# (example assumes a valid DVD-Video MPEG-2 file exists)
dvdauthor -o mydvd -a 0:en /path/to/input.mpg
dvdauthor -T -o mydvd
```

**Windows (using pre-built binary):**
1. Download `dvdauthor-windows-x86_64.zip` from [releases](https://github.com/prinsbert/dvdauthor/releases)
2. Extract the archive to your desired location (e.g., `C:\Program Files\dvdauthor`)
3. Add the `bin` directory to your system `Path` (or use full path when running commands)
4. Use commands as shown above, with `.exe` suffix:

```bash
# Create a DVD structure
dvdauthor.exe -o mydvd -a 0:en C:\path\to\input.mpg
dvdauthor.exe -T -o mydvd
```

> The exact audio/video options depend on your MPEG stream and desired DVD settings. See `dvdauthor -h` for the full list.

## See also

### FFmpeg

See <http://www.ffmpeg.org/>.

Note that packages included with your distro are almost certainly out of date. Always use the latest version from the Git repository or the latest release.

### mjpegtools

See <http://mjpeg.sourceforge.net>.

It includes `mplex` for building an MPEG-2 system stream with hooks for DVD-Video navigation packets.

### mpucoder's site on DVD specifications

See <http://www.mpucoder.com/DVD/>.

It contains details on the DVD-Video format.

### Inside DVD-Video on Wikibooks

See <http://en.wikibooks.org/wiki/Inside_DVD-Video>.

This is a work-in-progress wikibook designed to contain all publicly available information on DVD-Video, in a readable format.
