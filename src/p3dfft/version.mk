PKGROOT            = /opt/p3dfft/$(ROLLCOMPILER)/$(ROLLMPI)/$(ROLLNETWORK)
NAME               = p3dfft_$(ROLLCOMPILER)_$(ROLLMPI)_$(ROLLNETWORK)
VERSION            = 2.6
RELEASE            = 0

SRC_SUBDIR         = p3dfft

SOURCE_NAME        = p3dfft
SOURCE_VERSION     = $(VERSION)
SOURCE_SUFFIX      = tar.gz
SOURCE_PKG         = $(SOURCE_NAME)-$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR         = $(SOURCE_PKG:%.$(SOURCE_SUFFIX)=%)

TAR_GZ_PKGS           = $(SOURCE_PKG)
