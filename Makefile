.PHONY : build deps-default.png deps-preload.png test

build-all : build build-preload

build :
	cabal new-build --project-file=cabal.project --builddir=dist-newstyle all

build-preload :
	cabal new-build --project-file=cabal.project.preload --builddir=dist-newstyle-preload all

deps-default.png :
	cabal new-build --project-file=cabal.project --builddir=dist-newstyle all --dry
	cabal-plan --builddir=dist-newstyle-preload --hide-builtin dot --tred --tred-weights --path-from github --path-to basement | dot -Tpng -o $@

deps-preload.png :
	cabal new-build --project-file=cabal.project.preload --builddir=dist-newstyle-preload all --dry
	cabal-plan --builddir=dist-newstyle-preload --hide-builtin dot --tred --tred-weights --path-from github --path-to basement | dot -Tpng -o $@

test : build build-preload
	cabal new-run --project-file=cabal.project --builddir=dist-newstyle example
	cabal new-run --project-file=cabal.project.preload --builddir=dist-newstyle-preload example
