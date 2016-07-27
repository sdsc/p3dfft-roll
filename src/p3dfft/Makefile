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
include $(SDSCDEVEL)/Pull.mk
include $(SDSCDEVEL)/Rules.mk

#
# Note: ROLLMPI=rocks-openmpi requires use of the system compiler because of
# mpi.mod incompatibility
#

P3DFFT_CACHE = $(REDHAT.ROOT)/cache/build-p3dfft

$(NAME).spec: DESCRIPTION LICENSE

DESCRIPTION:
	if test "$(MPINAME)" != "rocks-openmpi"; then \
	  $(MODULE_LOAD_FC); \
	fi; \
	( \
	  $(DESCRIBE_PKG); \
	  $(DESCRIBE_FC); \
	  $(DESCRIBE_MPI); \
	  $(DESCRIBE_FFTW) \
	) > $@

LICENSE: $(SRC_DIRS)
	$(CHECK_LICENSE_FILES)
	echo GPLv3+ > $@

build: $(SRC_DIRS)
	@echo "::: Package $(NAME) build complete :::"
	
install::
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)/doc
	( \
	  $(MODULE_LOAD_FC); \
	  $(MODULE_LOAD_MPI); \
	  $(MODULE_LOAD_FFTW); \
	  fftwHome=$$FFTWHOME; \
	  if test "$(MPINAME)" = "rocks-openmpi"; then \
	    module unload $(ROLLCOMPILER); \
	  fi; \
	  if test -f $${MPIHOME}/lib/libmpi_f90.a; then \
	    perl -pi -e 's/lmpichf90/lmpi_f90/g' $(SOURCE_DIR)/configure; \
	  elif test -f $${MPIHOME}/lib/libmpi_mpifh.a; then \
	    perl -pi -e 's/lmpichf90/lmpi_mpifh/g' $(SOURCE_DIR)/configure; \
	  fi; \
	  export CC=mpicc; \
	  export FC=mpif90; \
	  export CFLAGS=-O3; \
	  export FCFLAGS=-O3; \
          export LDFLAGS="-lpthread -lm"; \
	  cd $(SOURCE_DIR); \
	  for lib in p3dfft-double p3dfft-double-noncontiguous p3dfft-single p3dfft-single-noncontiguous; do \
	    singleopt= ; \
	    strideopt= ; \
	    if echo $$lib | grep -q single; then \
	      singleopt=--enable-single; \
	    fi; \
	    if echo $$lib | grep -q noncontinuous; then \
	      strideopt=--enable-stride; \
	    fi; \
	    ./configure --prefix=$(P3DFFT_CACHE)/$$lib \
	                --enable-$(COMPILERNAME) \
	                --enable-fftw --with-fftw=$$fftwHome \
	                $$singleopt $$strideopt; \
	    $(MAKE) || exit 2; \
	    $(MAKE) install || exit 2; \
	    mkdir -p -m 755 $(ROOT)/$(PKGROOT)/share/p3dfft-samples/$$lib; \
            echo "LIB FILE"; \
            ls -l $(ROOT)/$(PKGROOT)/lib; \
	    if test \! -e $(ROOT)/$(PKGROOT)/lib; then \
	      cp -r $(P3DFFT_CACHE)/$$lib/* $(ROOT)/$(PKGROOT)/; \
	      ln -s libp3dfft.a $(ROOT)/$(PKGROOT)/lib/lib$$lib.a; \
	      ln -s p3dfft.mod $(ROOT)/$(PKGROOT)/include/$$lib.mod; \
	      mv $(ROOT)/$(PKGROOT)/share/p3dfft-samples/*.x $(ROOT)/$(PKGROOT)/share/p3dfft-samples/$$lib; \
	    else \
	      cp $(P3DFFT_CACHE)/$$lib/lib/libp3dfft.a $(ROOT)/$(PKGROOT)/lib/lib$$lib.a; \
	      cp $(P3DFFT_CACHE)/$$lib/include/p3dfft.mod $(ROOT)/$(PKGROOT)/include/$$lib.mod; \
	      cp $(P3DFFT_CACHE)/$$lib/share/p3dfft-samples/*.x $(ROOT)/$(PKGROOT)/share/p3dfft-samples/$$lib; \
	    fi; \
	    make clean; \
	  done; \
	  cp P3DFFT_User_Guide_2.7.1.pdf $(ROOT)/$(PKGROOT)/doc \
	)
	$(INSTALL_LICENSE_FILES)
	@echo "::: Package $(NAME) install complete :::"

clean::
	rm -rf $(SOURCE_DIR) DESCRIPTION LICENSE
