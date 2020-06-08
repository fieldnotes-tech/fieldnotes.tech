---
title: "Fix Macbook Pro Unstable Bluetooth"
date: 2020-06-16T16:21:00Z
tags:
- mac
- bluetooth
- solved
---

Solved problems with bluetooth audio crackling, cutting out and disconnecting, on MacBook Pro by running this:

```
sudo defaults write /Library/Preferences/com.apple.airport.bt.plist bluetoothCoexMgmt Hybrid
```

