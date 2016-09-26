DIST=dist
CBD=cabal
STYLE=stylish-haskell

default: build

init:
	$(CBD) sandbox init
	$(CBD) install --job=2 --only-dependencies --enable-tests

clean:
	rm -rf $(DIST)

create-keys:
	test -e example/Keys.hs || cp example/Keys.hs.sample example/Keys.hs

conf: create-keys
	$(CBD) configure --enable-tests -ftest

build: conf
	$(CBD) build

test:
	$(CBD) test

rebuild: clean build

install: build
	$(CBD) install

ci: init build test

ci-stack: create-keys
	stack build --test

hlint:
	$(STYLE) -i src/Network/OAuth/**/*.hs
	$(STYLE) -i src/Network/OAuth/*.hs
	$(STYLE) -i example/*.hs
	$(STYLE) -i example/*.hs.sample
	$(STYLE) -i example/**/*.hs
	hlint src/ example --report=$(DIST)/hlint.html

doc: build
	$(CBD) haddock

dist: build
	$(CBD) sdist

####################
### Tests
####################

test-weibo:
	./dist/build/test-weibo/test-weibo

test-douban:
	./dist/build/test-douban/test-douban

test-google:
	./dist/build/test-google/test-google

test-facebook:
	./dist/build/test-facebook/test-facebook

test-github:
	./dist/build/test-github/test-github

test-fitbit:
	./dist/build/test-fitbit/test-fitbit

test-stackexchange:
	./dist/build/test-stackexchange/test-stackexchange
