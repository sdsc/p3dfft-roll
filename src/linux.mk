SRCDIRS = `find * -prune\
	  -type d 	\
	  ! -name CVS	\
	  ! -name p3dfft-modules \
	  ! -name build-*	\
	  ! -name .` p3dfft-modules 
