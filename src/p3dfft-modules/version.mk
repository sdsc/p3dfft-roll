PACKAGE     = p3dfft
CATEGORY    = applications

NAME        = sdsc-$(PACKAGE)-modules
RELEASE     = 2
PKGROOT     = /opt/modulefiles/$(CATEGORY)/$(PACKAGE)

VERSION_SRC = $(REDHAT.ROOT)/src/$(PACKAGE)/version.mk
VERSION_INC = version.inc
include $(VERSION_INC)

RPM.EXTRAS  = AutoReq:No\nObsoletes:sdsc-p3dfft-modules_gnu,sdsc-p3dfft-modules_intel,sdsc-p3dfft-modules_pgi
