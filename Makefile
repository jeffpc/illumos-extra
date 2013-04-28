#
# CDDL HEADER START
#
# The contents of this file are subject to the terms of the
# Common Development and Distribution License, Version 1.0 only
# (the "License").  You may not use this file except in compliance
# with the License.
#
# You can obtain a copy of the license at COPYING
# See the License for the specific language governing permissions
# and limitations under the License.
#
# When distributing Covered Code, include this CDDL HEADER in each
# file and include the License file at COPYING.
# If applicable, add the following below this CDDL HEADER, with the
# fields enclosed by brackets "[]" replaced with your own identifying
# information: Portions Copyright [yyyy] [name of copyright owner]
#
# CDDL HEADER END
#
# Copyright (c) 2013, Joyent, Inc.
#

BASE =		$(PWD)
DESTDIR =	$(BASE)/proto-$(ARCH)
PATH =		$(DESTDIR)/usr/bin:/opt/gcc/4.4.4/bin:/usr/bin:/usr/sbin:/sbin:/opt/local/bin

SUBDIRS = \
	cpp

STRAP_SUBDIRS = \
	cpp

GCC_SUBDIRS = \
	gmp \
	mpfr \
	mpc

NAME =	illumos-extra

AWK =		$(shell (which gawk 2>/dev/null | grep -v "^no ") || which awk)
BRANCH =	$(shell git symbolic-ref HEAD | $(AWK) -F/ '{print $$3}')

ifeq ($(TIMESTAMP),)
  TIMESTAMP = $(shell date -u "+%Y%m%dT%H%M%SZ")
endif

#
# Ensure ARCH is set from the outside
#
ifeq ($(ARCH),)
$(error ARCH is not defined. ARCH should be one of i86pc or arm)
endif

ifeq ($(ARCH),arm)
ifeq ($(LD_ALTEXEC),)
$(error LD_ALTEXEC should point to an arm ld)
endif
endif

ifneq ($(STRAP),strap)
$(error only building the strap is supported currently)
endif

GITDESCRIBE = \
	g$(shell git describe --all --long | $(AWK) -F'-g' '{print $$NF}')

TARBALL =	$(NAME)-$(BRANCH)-$(TIMESTAMP)-$(GITDESCRIBE).tgz

all: $(SUBDIRS)

strap: $(STRAP_SUBDIRS)

mpfr: gmp 
mpc: mpfr gmp

#
# pkg-config may be installed. This will actually only hurt us rather than help
# us. pkg-config is based as a part of the pkgsrc packages and will pull in
# versions of libraries that we have in /opt/local rather than using the ones in
# /usr that we want. PKG_CONFIG_LIBDIR controls the actual path. This
# environment variable nulls out the search path. Other vars just control what
# gets appended.
#

$(DESTDIR)/usr/gnu/bin/gas: FRC
	(cd binutils && \
	    PKG_CONFIG_LIBDIR="" \
	    STRAP=$(STRAP) \
	    $(MAKE) DESTDIR=$(DESTDIR) install)


$(DESTDIR)/usr/bin/gcc: $(DESTDIR)/usr/gnu/bin/gas $(GCC_SUBDIRS)
	(cd gcc4 && \
	    PKG_CONFIG_LIBDIR="" \
	    STRAP=$(STRAP) \
	    $(MAKE) DESTDIR=$(DESTDIR) install)

#
# XXX
# The libtool library archives pathologically encode the full name of the
# library in the *.la file. Therefore when dependents comes around say mpc on
# mpfr, they look around for the library in question and basically lose DESTDIR
# off the prefix. We could perhap set prefix and override how the install target
# works here, but that seems bad. All in all, libtool hell is a great place to
# be.
#
$(GCC_SUBDIRS): FRC
	(cd $@ && \
	    PKG_CONFIG_LIBDIR="" \
	    STRAP=$(STRAP) \
	    $(MAKE) DESTDIR=$(DESTDIR) install && rm -f $(DESTDIR)/usr/lib/*.la)

$(SUBDIRS): $(DESTDIR)/usr/bin/gcc
	(cd $@ && \
	    PKG_CONFIG_LIBDIR="" \
	    STRAP=$(STRAP) \
	    $(MAKE) DESTDIR=$(DESTDIR) install)

install: $(SUBDIRS) gcc4 binutils

install_strap: $(STRAP_SUBDIRS) gcc4 binutils $(GCC_SUBDIRS)

clean: 
	-for dir in $(SUBDIRS) gcc4 binutils $(GCC_SUBDIRS); \
	    do (cd $$dir; $(MAKE) DESTDIR=$(DESTDIR) clean); done
	-rm -rf proto

manifest:
	cp manifest $(DESTDIR)/$(DESTNAME)

FRC:

.PHONY: manifest
