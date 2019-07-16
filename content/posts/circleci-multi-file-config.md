---
title: "Multi-File CircleCI Config"
date: 2019-07-16T21:21:00Z
tags:
- circleci
- workflow
- make
---

CircleCI configuration for complex projects can grow very large. By default you have to store all that configuration in a single `.circleci/config.yml` which quickly gets unmanageable. Compounded with that, is that if you are using the on-prem CircleCI Enterprise, you are limited to using CircleCI 2.0 syntax, which is missing some really useful code reuse features like Commands, Executors and Orbs.

I was frustrated by these problems on a recent project with complex CI requirements, so, with a little nudge by a colleague who knew the CircleCI CLI inside out, I came up with a solution...

If you just want to use it, head over to  https://github.com/samsalisbury/circleci-multi-file-config where you'll see all the instructions you need to get started. If you are interested in the nitty gritty, then please subscribe to this blog and I will post a more detailed breakdown soon.
