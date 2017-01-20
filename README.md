# homebrew-os161

[Homebrew] formulae for installing [System/161] and an [OS/161]
cross-compiling toolchain on OS X.

**Supported versions:**

* System/161 2.0.8
* OS/161 2.0.2
  * Binutils 2.24+os161-2.1
  * GCC 4.8.3+os161-2.1
  * GDB 7.8+os161-2.1

These packages are downloaded from the [official Harvard
sources][161-download].

## Quick start

With [Homebrew] installed, run

```bash
$ brew tap benesch/os161
$ brew install bmake sys161 os161-gcc os161-gdb
```

then follow the standard OS/161 spinup guide.


## Detailed installation instructions

### Homebrew tap

Install Homebrew from http://brew.sh if you don't have it already.
Then, add this repository as a [custom tap] so Homebrew can find the
OS161-specific formula:

```bash
$ brew tap benesch/os161
```

### System/161

First, install the System/161 MIPS simulator.

```bash
$ brew install sys161
```

At this point, `sys161` will be available in your PATH and runnable. A
sample `sys161.conf` is installed to:

    /usr/local/share/examples/sys161/sys161.conf.sample


### GCC

Then, you need a cross-compiling GCC capable of building executables for
System/161:

```bash
$ brew install os161-gcc
```

This will install a GCC toolchain prefixed with `mips-harvard-os161-`
into your PATH.


### GDB

Optionally, you might want a GDB capable of debugging executables built
for System/161:

```bash
$ brew install os161-gdb
```

This installs `mips-harvard-os161-gdb`. You may wish to set a shorter
shell alias:

```bash
$ echo alias os161-gdb=mips-harvard-os161-gdb >> ~/.bash_profile
```


## OS/161

To set up stock OS/161 in a nutshell:

```bash
# Obtain sources
$ wget http://os161.eecs.harvard.edu/download/os161-base-2.0.2.tar.gz
$ tar xf os161-base-2.0.2.tar.gz

# Build userland
$ cd os161-base-2.0.2
$ ./configure
$ bmake
$ bmake install

# Build kernel
$ cd kern/conf
$ ./config DUMBVM
$ cd ../compile/DUMBVM
$ bmake depend
$ bmake
$ bmake install

# Run kernel
$ cd ~/os161/root
$ cp /usr/local/share/examples/sys161/sys161.conf.sample sys161.conf
$ sys161 kernel
```

See the [OS/161 guides and resources] for next steps.


[Homebrew]: http://brew.sh
[System/161]: http://os161.eecs.harvard.edu/#sys161
[OS/161]: http://os161.eecs.harvard.edu/
[OS/161 guides and resources]: http://os161.eecs.harvard.edu/resources/
[161-download]: http://os161.eecs.harvard.edu/download/
[custom tap]: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/brew-tap.md
