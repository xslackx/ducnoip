#!/bin/bash
function wizard()
{

if [[ $(ls) =~ noip-duc_([0-9].{1,4}).tar.gz ]]; then

    duc_version=${BASH_REMATCH[1]}
    duc_tar=${BASH_REMATCH[0]}
    duc_folder=${duc_tar%%.tar.gz}
    echo -e "Dynamic DNS Update Client (DUC) version ${duc_version}\n"

fi && \
tar xf $duc_tar && \
cd $duc_folder/binaries && \
for typeos in "_amd64" "_arm64" "_armhf"; do
    for machine in "x86_64" "aarch64" "armhf"; do

        if [[ $(uname -m) == $machine ]]; then
            package="${duc_folder}${typeos}.deb"
            found=true
            break
        fi

    done
    if $found; then break; fi
done && \
dpkg -i $package

}

wizard