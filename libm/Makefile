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
# Copyright (c) 2013, Joyent, Inc.  All rights reserved.
#

BASE=$(PWD)
DESTDIR=$(BASE)/../proto

include ../Makefile.defs

all: 
	(cd usr/src/harness; env - \
	    SUN_MAKE=$(SUN_MAKE) \
	    $(SUN_MAKE) -f Makefile-os \
	    STRIP=/usr/bin/strip MCS=/usr/bin/mcs LD=/usr/bin/ld)

install: all
	BASE=$(DESTDIR) ksh93 ./install-extra

clean:
	rm -rf destdir statdir SUNWlibm usr/src/libm/wos/f80387 \
	usr/src/libm/wos/libmvec usr/src/libm/wos64/amd64

