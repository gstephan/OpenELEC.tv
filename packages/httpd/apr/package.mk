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

PKG_NAME="apr"
PKG_VERSION="1.5.0"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="OpenSource"
PKG_SITE="http://www.linuxfromscratch.org/blfs/view/svn/general/apr.html"
PKG_URL="http://archive.apache.org/dist/apr/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain apr:host"
PKG_PRIORITY="optional"
PKG_SECTION="web"
PKG_SHORTDESC="The Apache Portable Runtime"
PKG_LONGDESC="The Apache Portable Runtime (APR) is a supporting library for the Apache web server."
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--disable-static \
                           --disable-libtool-lock \
                           --disable-lfs \
                           --enable-dso \
                           --disable-ipv6 \
                           --with-gnu-ld \
                           ac_cv_file__dev_zero=no \
                           ac_cv_func_setpgrp_void=no \
                           apr_cv_tcp_nodelay_with_cork=no \
                           cross_compiling=yes \
                           apr_cv_process_shared_works=no \
                           ac_cv_sizeof_struct_iovec=1"

PKG_CONFIGURE_OPTS_HOST="--disable-static \
                         --disable-libtool-lock \
                         --disable-lfs \
                         --enable-dso \
                         --disable-ipv6 \
                         --with-gnu-ld \
                         ac_cv_file__dev_zero=no \
                         ac_cv_func_setpgrp_void=no \
                         apr_cv_tcp_nodelay_with_cork=no \
                         cross_compiling=no \
                         apr_cv_process_shared_works=no \
                         ac_cv_sizeof_struct_iovec=1"

pre_configure_target() {
  export RM="rm -f"
}
 
pre_configure_host() {
  pre_configure_target
}

post_configure_target() {
  $HOST_CC ../tools/gen_test_char.c -o gen_test_char
  ./gen_test_char >include/apr_escape_test_char.h
  sed -i 's|tools/gen_test_char >|echo |' Makefile
}

post_configure_host() {
  post_configure_target
}

makeinstall_host() {
  : # nothing to install
}
