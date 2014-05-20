################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)
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

PKG_NAME="apr-util"
PKG_VERSION="1.5.3"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="OpenSource"
PKG_SITE="http://www.linuxfromscratch.org/blfs/view/svn/general/apr-util.html"
PKG_URL="http://archive.apache.org/dist/apr/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain apr apr-util:host"
PKG_PRIORITY="optional"
PKG_SECTION="web"
PKG_SHORTDESC="The Apache Portable Runtime Utility Library provides a predictable and consistent interface to underlying client library interfaces."
PKG_LONGDESC="The Apache Portable Runtime Utility Library provides a predictable and consistent interface to underlying client library interfaces."
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

# host is build before target
pre_configure_host() {
  # we need apr folder so build it first (could be done better probably)
  (
    cd $ROOT
    $SCRIPTS/build apr
  )
 
  APR_DIR_HOST=$(ls -d $ROOT/$BUILD/apr-[0-9]*/.$HOST_NAME)

  PKG_CONFIGURE_OPTS_HOST="--with-apr=$APR_DIR_HOST \
                           --with-openssl \
                           --with-crypto"
}

pre_configure_target() {
  APR_DIR_TARGET=$(ls -d $ROOT/$BUILD/apr-[0-9]*/.$TARGET_NAME)

  PKG_CONFIGURE_OPTS_TARGET="--with-apr=$APR_DIR_TARGET \
                             --with-openssl \
                             --with-crypto"
}

makeinstall_host() {
  : # nothing to install
}
