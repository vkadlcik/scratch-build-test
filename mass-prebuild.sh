#!/bin/bash

set -x

rm -rf ~/.cache/copr/*

mkdir -p ~/.config
cat $COPR_CONFIG > ~/.config/copr

#cp -r .mpb ~/
# yum install -y expect
# hostname
# ip a
# unbuffer mpb

FEDRELEASE=38

cat > work.sh <<EOFA
#!/bin/bash
cat /etc/redhat-release
dnf -y copr enable fberat/mass-prebuild
dnf -y install mass-prebuild copr-cli expect
copr-cli whoami
unbuffer mpb
EOFA

mkdir .mpb
cat > .mpb/config <<EOFB
packages:
  colorgcc:
    src_type: url
    src: https://kojipkgs.fedoraproject.org//packages/colorgcc/1.4.5/20.fc39/src/colorgcc-1.4.5-20.fc39.src.rpm
build_id: 0
verbose: 5
revdeps:
  list:
    - colorgcc
EOFB

rpm -q toolbox || \
	dnf -y install --enablerepo=epel toolbox
mkdir -p ~/.config/toolbox
toolbox list | fgrep fedora-toolbox-${FEDRELEASE} || \
	toolbox create --distro fedora --release ${FEDRELEASE}
toolbox run --container fedora-toolbox-${FEDRELEASE} bash work.sh



exit 0
