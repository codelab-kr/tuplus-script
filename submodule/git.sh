#!/bin/bash

msg=$@

if [[ -z "$msg" ]]; then
  echo "Error: commit message not provided"
  exit 1
fi;


echo "======== Submodule Repo Update ========";
echo "msg: $msg" |  git submodule foreach --recursive \
'if [[ $(git status --porcelain) ]]; then \
  echo "msg: '"$msg"'" && \
  git pull && git add . && git commit -m "'"$msg"'" && git push; \
fi;' || :

echo "\n======== Main Repo Update ========"
if [[ $(git status --porcelain) ]]; then \
  git pull && git add . && git commit -m "$@" && git push; \
fi || :