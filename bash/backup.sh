#!/usr/bin/env bash
set -e

SRC="/home/timmy/data"
DST="/home/timmy/backup"

mkdir -p "$DST"

rsync -a "$SRC"/ "$DST"/