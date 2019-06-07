# android-clang-external

This project shows how to build C app external w.r.t. Android, using Android
clang. Cross-compiling is set to Cortex-A15 ARMv7 (32-bit ARM).
 Usage example:

```
$ cd aosp
$ . build/envsetup.sh
$ lunch beagle_x15-userdebug
$ cd this/project
$ ./build.sh
```

There are 3 versions of `Makefile` available here:

- `Makefile.android-vanilla`: incorporates all `CFLAGS` and `LDFLAGS` found from
  Android build
- `Makefile`: moderately stripped flags (only 100% unnecessary flags are
  removed)
- `Makefile.minimal`: only 100% required flags are left here

It's probably better to use flags from `Makefile` for production projects.

Here is how I found out all clang build flags from Android build:

```
$ . build/envsetup.sh
$ lunch beagle_x15-userdebug
$ cd external/mtpd
$ mm showcommands
$ gzip -cd ../../out/verbose.log.gz | less -R
```

Similar procedure could be use to figure out ARMv8 build flags.
