#
# CDDL HEADER START
#
# The contents of this file are subject to the terms of the
# Common Development and Distribution License, Version 1.0 only
# (the "License").  You may not use this file except in compliance
# with the License.
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
#
# Copyright 2006 Sun Microsystems, Inc.  All rights reserved.
# Use is subject to license terms.
#
# ident	"%Z%%M%	%I%	%E% SMI"
#
# lib/libeti/panel/Makefile.com
#

LIBRARY=	libpanel.a
VERS=		.1

OBJECTS=  \
	bottom.o \
	move.o \
	replace.o \
	update.o \
	delete.o \
	misc.o \
	new.o \
	top.o

# include library definitions
include ../../../Makefile.lib

MAPFILE=        $(MAPDIR)/mapfile

LIBS =          $(DYNLIB) $(LINTLIB)

SRCDIR=		../common

$(LINTLIB) :=	SRCS=$(SRCDIR)/$(LINTSRC)

CPPFLAGS +=	-I../inc
CFLAGS +=       $(CCVERBOSE)
DYNFLAGS +=     -M $(MAPFILE)
LDLIBS +=       -lcurses -lc

.KEEP_STATE:

all: $(LIBS) fnamecheck

lint: lintcheck

$(DYNLIB):      $(MAPFILE)

$(MAPFILE):
	@cd $(MAPDIR); $(MAKE) mapfile

# include library targets
include ../../../Makefile.targ

pics/%.o:	../common/%.c
	$(COMPILE.c) -o $@ $<
	$(POST_PROCESS_O)
