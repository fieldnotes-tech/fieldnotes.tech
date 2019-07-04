---
title: "How to SHELL for compatible Makefiles"
date: 2019-07-04T08:56:00Z
tags:
- make
- pragmatism
- bash
---

The upshot is if you care about maximum compatibility with different versions of GNU Make,
don't use `.SHELLFLAGS` just put all your args in-line in the `SHELL` variable,
and make sure to always always use `-c` as your last argument.
E.g. for bash in "strict mode"

```Makefile
SHELL := /usr/bin/env bash -euo pipefail -c
```

## But why?

I really care about the out of the box development experience on projects I maintain.
For me, this currently means ensuring that you can at least
build and run tests on vanilla macOS and GNU/Linux distros,
without having to upgrade standard tools like, for example, `make`.

Currently, macOS Mojave ships with `GNU Make 3.81`, from 2006.
Most modern GNU/Linux distros ship with GNU Make 4+,
`GNU Make 4.2.1` from 2016 being the latest at time of writing.

In those 10 years, breaking changes were made to the handling of the `SHELL` variable itself,
and a new special variable called `.SHELLFLAGS` was introduced:

* Make 4+ no longer auto-inserts the `-c` flag for your `SHELL` variable, resulting in very confusing output (see below) if you forget to add it.
* Make 4- does not recognise the `.SHELLFLAGS` variable at all, so we can't use it.

These are all perfectly logical steps
to make Make more versatile and enable handling of different shells
outside of POSIX-conforming shells like
sh, dash, ash and bash.
However this spread of versions encountered in the wild
means we need to find a middle way,
not strictly adhering to guidance about placing too many args in your shebang line
(`SHELL` is not actually a shebang line, it just looks a bit like one),
but rather discovering what works in practice and applying that.

The conclusion?
Put your shell executable and all of its flags in the `SHELL` variable,
and don't forget to add `-c`, or your shell-of-choice's equivalent flag, right at the end.
Happy Making!

Have I missed something here? Is there a better way? Let me know in the comments!
