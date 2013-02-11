#
# CDDL HEADER START
#
# The contents of this file are subject to the terms of the
# Common Development and Distribution License (the "License").
# You may not use this file except in compliance with the License.
#
# You can obtain a copy of the license at usr/src/OPENSOLARIS.LICENSE
# or http://www.opensolaris.org/os/licensing.
# See the License for the specific language governing permissions
# and limitations under the License.
#
# When distributing Covered Code, include this CDDL HEADER in each
# file and include the License file at usr/src/OPENSOLARIS.LICENSE.
# If applicable, add the following below this CDDL HEADER, with the
# fields enclosed by brackets "[]" replaced with your own identifying
# information: Portions Copyright [yyyy] [name of copyright owner]
#
# CDDL HEADER END
#
# Copyright 2010 Sun Microsystems, Inc.  All rights reserved.
# Use is subject to license terms.
# Copyright (c) 2013, Joyent, Inc.  All rights reserved.
#

#
# This makefile has not been adapted to use the infrastructure because of
# the need to build in a separate subdirectory from the source.  This could
# be accommodated without excessive effort but is a highly unusual pattern.
#

VER =	gcc-4.6.3
NEWLIB = newlib-2.0.0

include ../Makefile.defs

CLEANFILES +=	$(VER)-$(ARCH)-build

GCC =	gcc
GXX =	/bin/false

arm_PATCHES += arm.patch
arm_TARGET_OPTS = \
	--target=arm-*-solaris2.11 \
	--with-arch=armv6 \
	--with-fpu=vfp \
	--with-float=hard \
	--with-abi=aapcs \
	--with-mode=arm \
	--with-newlib \
	--disable-multilib \
	--enable-languages="c" \
	--disable-libssp \
	--disable-libada \
	--disable-libgomp

i86pc_TARGET_OPTS= \
	--enable-languages="c,c++" \
	--target=i386-pc-solaris2.11

include ../Makefile.targ

all: $(VER)-$(ARCH)-build/config.status
	(cd $(VER)-$(ARCH)-build; env - \
	    CC=$(GCC) \
	    CFLAGS="-g -O2" \
	    DESTDIR=$(DESTDIR) \
	    PATH=$(PATH) \
	    STAGE1_CFLAGS="-g -O2" \
	    CFLAGS_FOR_TARGET="-g -O2" \
	    MAKE=gmake gmake \
	    LD_LIBRARY_PATH="$(DESTDIR)/usr/lib:/opt/gcc/4.4.4/lib:/lib:/usr/lib:/usr/sfw/lib" \
	    LD_ALTEXEC=$(LD_ALTEXEC) \
		CFLAGS="-g -O2" \
		STAGE1_CFLAGS="-g -O2" \
		AR_FOR_TARGET=$(DESTDIR)/usr/gnu/bin/gar \
		NM_FOR_TARGET=$(DESTDIR)/usr/gnu/bin/gnm \
		OBJDUMP_FOR_TARGET=$(DESTDIR)/usr/gnu/bin/gobjdump \
		RANLIB_FOR_TARGET=$(DESTDIR)/usr/gnu/bin/granlib \
		CFLAGS_FOR_TARGET="-g -O2" $(PARALLEL))

install: all
	(cd $(VER)-$(ARCH)-build; env - \
	    CC=$(GCC) \
	    CFLAGS="-g -O2" \
	    STAGE1_CFLAGS="-g -O2" \
	    CFLAGS_FOR_TARGET="-g -O2" \
	    DESTDIR=$(DESTDIR) \
	    PATH=$(PATH) \
	    LD_LIBRARY_PATH="$(DESTDIR)/usr/lib:/opt/gcc/4.4.4/lib:/lib:/usr/lib:/lib:/usr/sfw/lib" \
	    LD_ALTEXEC=$(LD_ALTEXEC) \
	    MAKE=gmake gmake \
		CFLAGS="-g -O2" \
		STAGE1_CFLAGS="-g -O2" \
		AR_FOR_TARGET=$(DESTDIR)/usr/gnu/bin/gar \
		NM_FOR_TARGET=$(DESTDIR)/usr/gnu/bin/gnm \
		OBJDUMP_FOR_TARGET=$(DESTDIR)/usr/gnu/bin/gobjdump \
		RANLIB_FOR_TARGET=$(DESTDIR)/usr/gnu/bin/granlib \
		CFLAGS_FOR_TARGET="-g -O2" $(PARALLEL) install)

$(VER.32)/newlib: $(VER.32)/configure
	rm -rf $(VER.32)/newlib
	tar xzf $(NEWLIB).tar.gz -C $(VER.32)
	mv $(VER.32)/$(NEWLIB)/newlib $(VER.32)
	rm -rf $(VER.32)/$(NEWLIB)

$(VER)-$(ARCH)-build/config.status: $(VER)-$(ARCH)-build $(VER.32)/configure $(VER.32)/newlib
	(cd $(VER)-$(ARCH)-build; env - \
	    CC=$(GCC) \
	    CFLAGS="-g -O2" \
	    DESTDIR=$(DESTDIR) \
	    PATH=$(PATH) \
	    MAKE=gmake \
	    LD_ALTEXEC=$(LD_ALTEXEC) \
	../$(VER.32)/configure \
		--prefix=/usr \
		--with-ld=/usr/bin/ld \
		--without-gnu-ld \
		--with-gnu-as \
		--with-as=$(DESTDIR)/usr/gnu/bin/gas \
		--enable-shared \
		--disable-nls \
		--with-included-gettext \
		--with-gmp=$(DESTDIR)/usr \
		--with-mpfr=$(DESTDIR)/usr \
		--with-mpc=$(DESTDIR)/usr \
		$($(ARCH)_TARGET_OPTS))

$(VER)-$(ARCH)-build:
	mkdir -p $@
