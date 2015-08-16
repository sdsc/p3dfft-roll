ifndef ROLLCOMPILER
  COMPILERNAME = gnu
endif
COMPILERNAME := $(firstword $(subst /, ,$(ROLLCOMPILER)))

PACKAGE     = p3dfft
CATEGORY    = applications

NAME        = sdsc-$(PACKAGE)-modules_$(COMPILERNAME)
RELEASE     = 1
PKGROOT     = /opt/modulefiles/$(CATEGORY)/.$(COMPILERNAME)/$(PACKAGE)

VERSION_SRC = $(REDHAT.ROOT)/src/$(PACKAGE)/version.mk
VERSION_INC = version.inc
include $(VERSION_INC)

RPM.EXTRAS  = AutoReq:No
