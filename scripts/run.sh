#!/bin/bash

./scripts/build.sh
./app.exe
cp pages/index.html generated/
cp -r static generated/
