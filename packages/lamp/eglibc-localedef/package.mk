################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)
#      Copyright (C) 2014 ultraman
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

PKG_NAME="eglibc-localedef"
PKG_VERSION="2.19-25249"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.eglibc.org/"
PKG_URL="$DISTRO_SRC/$PKG_NAME-$PKG_VERSION.tar.xz" 
PKG_DEPENDS_TARGET="toolchain eglibc-localedef:host"
PKG_PRIORITY="optional"
PKG_SECTION="utility"
PKG_SHORTDESC="locale"
PKG_LONGDESC="locale"
PKG_MAINTAINER="ultraman"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_host() {
	EGLIBC_SRC_DIR=$(ls -d $ROOT/$BUILD/eglibc-[0-9]*)

  PKG_CONFIGURE_OPTS_HOST="--prefix=$ROOT/$PKG_BUILD \
                           --with-glibc=$EGLIBC_SRC_DIR"
}

make_host() {
	# http://cross-lfs.org/view/clfs-sysroot/arm/cross-tools/eglibc.html
	SUPPORTED_LOCALES="en_US.UTF-8/UTF-8"

	make SUPPORTED-LOCALES=$SUPPORTED_LOCALES install-locales
}

makeinstall_host() {
  : # nothing
}

# nothing for target

configure_target() {
  : # nothing
}

make_target() {
  : # nothing
}

makeinstall_target() {
  : # nothing
}
