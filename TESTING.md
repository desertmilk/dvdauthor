# DVDAuthor End-to-End Testing Guide

## TL;DR - Just Run This

**Verify the system works:**

```bash
# Option 1: Fast configuration test (5-10 seconds)
./test-config

# Option 2: Full build test (2-5 minutes, requires flex/bison)
./test

# Option 3: Manual step-by-step 
./bootstrap
./configure --disable-dvdunauthor
make -C src
```

## Test Overview

### `test-config` - Configuration Verification (Easiest)
- Runs bootstrap and configure only
- Verifies build system is properly initialized
- Checks for missing dependencies
- **Recommended for:**  Quick system validation, CI/CD pipelines, containers without full dev tools

```bash
./test-config
```

### `test` - Full Build Test (Most Comprehensive)
- Builds all binaries
- Verifies each binary executes
- Tests XML configuration framework
- Checks project structure

```bash
./test
```

### `test-e2e.sh` - Detailed Test Runner
Lower-level test script with detailed logging. Used by `test`.

### Manual Testing
For maximum control and understanding:

```bash
# Full build with everything
./bootstrap
./configure
make -j$(nproc)
make install

# Or minimal build (source only, no docs)
./bootstrap
./configure --disable-dvdunauthor
make -j$(nproc) -C src
make -C src install DESTDIR=/tmp/dvdauthor-install
```

## What Gets Tested

### Configuration Verification (`test-config`)
✓ Autotools bootstrap  
✓ Configure script generation  
✓ Makefile creation  
✓ Feature detection  

### Build & Binary Verification (`test`)
✓ Full source compilation  
✓ Binary creation:
  - `dvdauthor` - Main DVD creator
  - `spumux` - Subtitle/subpicture encoder
  - `spuunmux` - Subtitle decoder
  - `mpeg2desc` - MPEG-2 descriptor tool
✓ Binary execution  
✓ XML configuration parsing  

## Dependency Management

### Essential (Always Required)
```bash
gcc make autoconf automake pkg-config
```

### For Full Build
```bash
flex bison libtool libxml2-dev libpng-dev libfreetype6-dev libfontconfig1-dev
```

### Install All Prerequisites

**Ubuntu/Debian:**
```bash
sudo apt-get install -y build-essential autoconf automake libtool flex bison pkg-config libxml2-dev libpng-dev libfreetype6-dev libfontconfig1-dev
```

**macOS:**
```bash
brew install autoconf automake libtool flex bison pkg-config libxml2 libpng freetype fontconfig
```

### Scenario: Docker/Container Build
```dockerfile
FROM ubuntu:latest

RUN apt-get update && apt-get install -y build-essential autoconf automake libtool flex bison pkg-config libxml2-dev libpng-dev libfreetype6-dev libfontconfig1-dev

WORKDIR /build
COPY . /build/
RUN ./test-config  # Verify system
RUN ./bootstrap && ./configure && make -j$(nproc) -C src
```

## Troubleshooting

### "flex: command not found"
```bash
# Ubuntu/Debian
sudo apt-get install flex

# macOS
brew install flex
```

### "bison: command not found"
```bash
# Ubuntu/Debian
sudo apt-get install bison

# macOS
brew install bison
```

### "configure: error: missing libXXX"
Install missing development libraries:
```bash
# Ubuntu/Debian - check logs for which library
sudo apt-get install libxml2-dev libpng-dev ...

# macOS
brew install libxml2 libpng ...
```

### "docbook2man: command not found"
This is expected when building with `-C src` flag. The test skips documentation.

### Build succeeds but binaries missing
Check build output:
```bash
ls -la build-test/src/.libs/
# Binaries should be in .libs directory before install
```

### Test cleanup issues
If tests fail to cleanup:
```bash
rm -rf /workspaces/dvdauthor/build-test
rm -rf /workspaces/dvdauthor/build-simple-test
rm -rf /workspaces/dvdauthor/test-output
```

## Advanced Testing

### Build with All Features
```bash
./bootstrap
./configure  # Without --disable-dvdunauthor
make -j$(nproc)
make install
```

### Static Build
```bash
./bootstrap
./configure --disable-shared --enable-static
make -j$(nproc)
```

### Custom Installation
```bash
./bootstrap
./configure --prefix=/opt/dvdauthor --sysconfdir=/etc/dvdauthor
make -j$(nproc)
sudo make install
```

## What the Tests Verify

### Project Structure ✓
- Source files present and complete
- Build configuration files valid
- Dependencies discoverable

### Compilation ✓
- Code compiles without errors
- All required libraries found
- Binaries correctly generated

### Functionality ✓
- Binaries execute without crashing
- Help/version output works
- Configuration framework operational

### Integration ✓
- XML parsing works
- DVD structure framework functional
- All components work together

## Next Steps After Testing

Once tests pass:

1. **Use the tools:**
   ```bash
   dvdauthor -h  # See all options
   spumux -h     # Subtitle tool help
   mpeg2desc -h  # MPEG analysis tool
   ```

2. **Create your first DVD:**
   ```bash
   # Prepare MPEG files first
   dvdauthor -o my-dvd -x dvd-config.xml
   ```

3. **Read documentation:**
   - `doc/dvdauthor.sgml` - Full manual
   - `doc/spumux.sgml` - Subtitle encoding
   - README.md - Project overview

4. **Contribute:**
   - Report issues
   - Submit patches
   - Help with documentation

## Getting Help

- **Build Issues:** Check configure.log and make.log
- **Runtime Issues:** Run binaries with `-h` for options
- **Documentation:** See `doc/` directory
- **Project Home:** https://github.com/ldo/dvdauthor
