# Copyright (c) 2016 CoreOS, Inc.. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="CoreOS OEM suite for Google Compute Engine (meta package)"
HOMEPAGE=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

RDEPEND="
	app-emulation/google-compute-engine
	app-shells/bash
	sys-libs/glibc
	sys-libs/nss-usrfiles
"

S="${WORKDIR}"

src_compile() {
    touch "${T}/empty-file"
}

src_install() {
    # This is here only to avoid failures due to dangling symlinks
    # from ~core directory. Can't do it in manglefs - it's called too
    # late.
    local file
    insinto /usr/share/skel
    for file in .bash{_logout,_profile,rc}; do
        newins "${T}/empty-file" "${file}"
    done
}
