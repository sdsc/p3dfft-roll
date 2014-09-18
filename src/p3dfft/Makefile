#
# $Id$
#
# @Copyright@
# 
# 				Rocks(r)
# 		         www.rocksclusters.org
# 		       version 6.1.1 (Sand Boa)
# 
# Copyright (c) 2000 - 2014 The Regents of the University of California.
# All rights reserved.	
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
# 
# 1. Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
# 
# 2. Redistributions in binary form must reproduce the above copyright
# notice unmodified and in its entirety, this list of conditions and the
# following disclaimer in the documentation and/or other materials provided 
# with the distribution.
# 
# 3. All advertising and press materials, printed or electronic, mentioning
# features or use of this software must display the following acknowledgement: 
# 
# 	"This product includes software developed by the Rocks(r)
# 	Cluster Group at the San Diego Supercomputer Center at the
# 	University of California, San Diego and its contributors."
# 
# 4. Except as permitted for the purposes of acknowledgment in paragraph 3,
# neither the name or logo of this software nor the names of its
# authors may be used to endorse or promote products derived from this
# software without specific prior written permission.  The name of the
# software includes the following terms, and any derivatives thereof:
# "Rocks", "Rocks Clusters", and "Avalanche Installer".  For licensing of 
# the associated name, interested parties should contact Technology 
# Transfer & Intellectual Property Services, University of California, 
# San Diego, 9500 Gilman Drive, Mail Code 0910, La Jolla, CA 92093-0910, 
# Ph: (858) 534-5815, FAX: (858) 534-7345, E-MAIL:invent@ucsd.edu
# 
# THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS''
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# 
# @Copyright@
#
# $Log$
#

REDHAT.ROOT = $(CURDIR)/../../

-include $(ROCKSROOT)/etc/Rules.mk
include Rules.mk
include pull.mk

ifndef ROLLCOMPILER
  ROLLCOMPILER = gnu
endif
ifndef ROLLNETWORK
  ROLLNETWORK = eth
endif
ifndef ROLLMPI
  ROLLMPI = openmpi
endif


COMPILERSETUP = \
  if test -e /etc/profile.d/modules.sh; then \
    . /etc/profile.d/modules.sh; \
    latestModule=`module avail 2>&1 | grep -o '$(ROLLCOMPILER)/[^ (]*' | sed 's/$(ROLLCOMPILER).//' | sort -t. -k1,1n -k2,2n -k3,3n | tail -1`; \
    module load $(ROLLCOMPILER)/$${latestModule}; \
  fi

MPIMODULE = $(ROLLMPI)_$(ROLLNETWORK)

MPISETUP = \
  if test -e /etc/profile.d/modules.sh; then \
    . /etc/profile.d/modules.sh; \
    module load $(MPIMODULE); \
  fi; \
  export MPI_HOME=`which mpicxx | perl -pe 's!/bin/.*!!'`; \
  if test -z "$${MPI_HOME}"; then \
    export MPI_HOME=/opt/$(ROLLMPI); \
  fi; \
  echo Using MPI from $${MPI_HOME}; \
  export PATH=$${PATH}:$${MPI_HOME}/bin; \
  export LD_LIBRARY_PATH=$${LD_LIBRARY_PATH}:$${MPI_HOME}/lib

export CC=mpicc
export FC=mpif90
CONFIG_OPTS=-O3
COMPILER=--enable-gnu
ifeq ("$(ROLLCOMPILER)", "intel")
COMPILER=--enable-intel
else ifeq ("$(ROLLCOMPILER)", "pgi")
COMPILER=--enable-pgi
endif
LIBNAMES=p3dfft-double p3dfft-double-noncontiguous p3dfft-single p3dfft-single-noncontiguous
ifneq ("$(ROLLOPTS)", "$(subst avx,,$(ROLLOPTS))")
  ifneq ("$(COMPILERNAME)", "pgi")
    CONFIG_OPTS +=  --enable-avx
  endif
endif

  

build: $(SRC_DIRS)
	@echo "::: Package $(NAME) build complete :::"
	
install::
        
	mkdir -p $(ROOT)/$(PKGROOT)/doc
	mkdir -p $(REDHAT.ROOT)/src/build-p3dfft
	mkdir -p $(REDHAT.ROOT)/src/build-p3dfft-modules
	( \
            $(COMPILERSETUP); \
            $(MPISETUP); \
            module load fftw; \
            export CFLAGS="$(CONFIG_OPTS)"; \
            export FCFLAGS="$(CONFIG_OPTS)"; \
            OPTIONS=( " "  --enable-stride1 --enable-single --enable-single\ \--enable-stride1 ); \
            count=0; \
            cd $(SOURCE_DIR); \
            for lib in $(LIBNAMES); do \
               ./configure $(COMPILER) --prefix=$(REDHAT.ROOT)/src/build-p3dfft --enable-fftw --with-fftw=$${FFTWHOME} $${OPTIONS[$${count}]}; \
               $(MAKE); \
               $(MAKE) install; \
               mkdir -p $(ROOT)/$(PKGROOT)/share/p3dfft-samples/$${lib}; \
               if test $${count} -eq 0; then \
                   cp -r $(REDHAT.ROOT)/src/build-p3dfft/* $(ROOT)/$(PKGROOT); \
                   cd $(ROOT)/$(PKGROOT)/lib; \
                   ln -s libp3dfft.a lib$${lib}.a; \
                   cd $(ROOT)/$(PKGROOT)/include; \
                   ln -s p3dfft.mod $${lib}.mod; \
                   cd $(PWD)/$(SOURCE_DIR); \
               else \
                   cp $(REDHAT.ROOT)/src/build-p3dfft/lib/libp3dfft.a $(ROOT)/$(PKGROOT)/lib/lib$${lib}.a; \
                   cp $(REDHAT.ROOT)/src/build-p3dfft/include/p3dfft.mod $(ROOT)/$(PKGROOT)/include/$${lib}.mod; \
                   cp $(REDHAT.ROOT)/src/build-p3dfft/share/p3dfft-samples/*.x $(ROOT)/$(PKGROOT)/share/p3dfft-samples/$${lib}; \
               fi; \
               rm -rf $(REDHAT.ROOT)/src/build-p3dfft/*; \
               mv $(ROOT)/$(PKGROOT)/share/p3dfft-samples/*.x $(ROOT)/$(PKGROOT)/share/p3dfft-samples/$${lib}; \
               count=$$(( $${count} + 1 )); \
               cd ..; \
               rm -rf $(SOURCE_DIR); \
               tar xvzf $(SOURCE_PKG); \
               cd $(SOURCE_DIR); \
            done; \
            cp P3DFFT_User_Guide_2.7.1.pdf    $(ROOT)/$(PKGROOT)/doc \
        )
	cat p3dfft.module | perl -pi -e "s!MODULEROOT!/opt/modulefiles/applications/.$(ROLLCOMPILER)/p3dfft!g;s!VERSION!$(VERSION)!g;s!ROLLCOMPILER!$(ROLLCOMPILER)!g" \
          > $(REDHAT.ROOT)/src/build-p3dfft-modules/$(NAME).module

	@echo "::: Package $(NAME) install complete :::"

clean::
	rm -rf $(SOURCE_DIR)
