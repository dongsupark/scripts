# Copyright (c) 2020 Kinvolk GmbH. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd

DESCRIPTION="NVIDIA drivers"
HOMEPAGE=""
SRC_URI=""

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="arm64"
IUSE=""

# no source directory
S="${WORKDIR}"

src_install() {
  systemd_dounit "${FILESDIR}/units/nvidia.service"
  systemd_enable_service multi-user.target nvidia.service
  exeinto "/usr/lib/nvidia/bin"
  doexe "${FILESDIR}/bin/install-nvidia"
  doexe "${FILESDIR}/bin/setup-nvidia"
  cp "${FILESDIR}/nvidia-metadata" nvidia-metadata || die "cp failed"
  sed -i -e "s/@PV@/${PV}/" nvidia-metadata
  insinto "/usr/share/flatcar"
  doins nvidia-metadata
}
