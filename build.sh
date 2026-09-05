#!/bin/bash

rm -rf app.exe
rm -rf _build
dune build ./app.exe
cp _build/default/app.exe app.exe
