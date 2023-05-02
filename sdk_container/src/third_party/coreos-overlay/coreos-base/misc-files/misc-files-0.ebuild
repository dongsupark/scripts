# Copyright (c) 2023 The Flatcar Maintainers.
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION='Flatcar bashrc files'
HOMEPAGE='https://www.flatcar.org/'

LICENSE='Apache-2.0'
SLOT='0'
KEYWORDS='amd64 arm64'

# No source directory.
S="${WORKDIR}"

# Versions listed below are version of packages that shedded the
# modifications in their ebuilds.
RDEPEND="
	>=app-shells/bash-5.2_p15-r2
"

# Use absolute paths to be clear about what locations are used. The
# dosym below will make relative paths out of them.
#
# NOTE: The symlinks under /usr that point to entries under /etc will
# be retargeted to /usr/share/flatcar/etc when building an image
# later. Do not make them point to /usr/share/flatcar/etc here,
# because this directory does not exist now and won't exist at all
# during the whole packages build phase. We don't want to create
# dangling symlinks because the packages build phase also runs a root
# check at the end, and it will bail out on dangling symlinks.
COMPAT_SYMLINKS=(
    '/usr/share/bash/bash_logout'   '->' '/etc/bash/bash_logout'
    '/usr/share/bash/bashrc'        '->' '/etc/bash/bashrc'
    '/usr/share/skel/.bash_logout'  '->' '/etc/skel/.bash_logout'
    '/usr/share/skel/.bash_profile' '->' '/etc/skel/.bash_profile'
    '/usr/share/skel/.bashrc'       '->' '/etc/skel/.bashrc'
)

src_install() {
    insinto '/etc/bash/bashrc.d'
    doins "${FILESDIR}/99-flatcar-bcc"

    local idx link arrow target
    idx=0
    while [[ $((idx + 2)) -lt ${#COMPAT_SYMLINKS[@]} ]]; do
        link=${COMPAT_SYMLINKS[$((idx + 0))]}
        arrow=${COMPAT_SYMLINKS[$((idx + 1))]}
        target=${COMPAT_SYMLINKS[$((idx + 2))]}
        if [[ "${arrow}" != '->' ]]; then
            die "Malformed SYMLINKS array at index $((idx + 1))"
        fi
        dosym -r "${target}" "${link}"
        idx=$((idx + 3))
    done
}
