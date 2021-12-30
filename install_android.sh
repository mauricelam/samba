#!/bin/bash

targetpath=../samba-documents-provider
if [[ ! -d $targetpath ]];then
  echo "Cannot resolve path $targetpath" >&2
  exit 1
fi

rm -r $targetpath/app/src/main/jniLibs/arm64-v8a
rm -r $targetpath/app/src/main/cpp/samba_includes
./install.sh $targetpath/app/src/main/jniLibs/arm64-v8a
mv $targetpath/app/src/main/jniLibs/arm64-v8a/includes $targetpath/app/src/main/cpp/samba_includes
mv $targetpath/app/src/main/jniLibs/arm64-v8a/libsmbclient.so $targetpath/app/src/main/smblibs/arm64-v8a/libsmbclient.so
