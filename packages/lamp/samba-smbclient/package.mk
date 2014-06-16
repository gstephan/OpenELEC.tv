################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)
#      Copyright (C) 2009-2014 ultraman
#
#  OpenELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  OpenELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="samba-smbclient"
PKG_VERSION="1"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.samba.org"
PKG_URL=""
PKG_DEPENDS_TARGET="samba"
PKG_PRIORITY="optional"
PKG_SECTION="network"
PKG_SHORTDESC="smbclient is a ftp-like client to access SMB/CIFS resources on server. Part of samba."
PKG_LONGDESC="smbclient is a ftp-like client to access SMB/CIFS resources on server. Part of samba."
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

make_target() {
	echo "Building smbclient in original samba folder"
(
	cd $ROOT/$BUILD/samba-[0-9]*/.$TARGET_NAME
  make bin/smbclient
)
}

makeinstall_target() {
	: # do nothing (this is important)
}
