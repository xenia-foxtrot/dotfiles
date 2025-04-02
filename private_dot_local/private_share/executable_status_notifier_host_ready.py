#!/usr/bin/env python

import time
import sys
from dasbus.connection import SessionMessageBus
from dasbus.error import DBusError
bus = SessionMessageBus()

DBUS_SERVICE_NAME = "org.kde.StatusNotifierWatcher"
OBJECT_PATH = "/StatusNotifierWatcher"
INTERFACE_NAME = "org.kde.StatusNotifierWatcher"
MAX_LOOPS = 10
WAIT_TIME_SEC = 1
BACKOFF_FACTOR = 1.25

proxy = bus.get_proxy(DBUS_SERVICE_NAME, OBJECT_PATH, INTERFACE_NAME)

iters = 0
msg = ""
wait_time = 0

while iters < MAX_LOOPS:
    if wait_time > 0:
        print(f"Iter {iters}: {msg}: waiting {wait_time} sec")
        time.sleep(wait_time)

    try:
        if proxy.IsStatusNotifierHostRegistered:
            sys.exit(0)
        else:
            msg = "StatusNotifierHost not registered"
    except DBusError:
        msg = f"`{DBUS_SERVICE_NAME}` not registered"
    
    wait_time = round(WAIT_TIME_SEC * pow(BACKOFF_FACTOR, iters), 3)
    iters += 1

print(f"Iter {iters}: {msg}")
print("Failed to get service")
sys.exit(1)
