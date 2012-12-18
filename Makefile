RAVEN = ./src/raven.js
PARSEURI = ./src/vendor/uri.js
VER = $(shell cat version.txt)
RAVEN_FULL = ./dist/raven-${VER}.js
RAVEN_MIN = ./dist/raven-${VER}.min.js
TMP = /tmp/raven.min.js

.PHONY: raven test

#
# Build the compressed all-in-one file
#

develop:
	npm install .

raven:
	mkdir -p dist

	# Generate the full and compressed distributions
	cat ${PARSEURI} ${RAVEN} | \
		sed "s/@VERSION/${VER}/" > ${RAVEN_FULL}

	./node_modules/.bin/uglifyjs -c -o ${RAVEN_MIN} ${RAVEN_FULL}

	# Prepend the tiny header to the compressed file
	echo "/* Raven.js v${VER} | https://github.com/getsentry/raven-js/ */" | \
		cat - ${RAVEN_MIN} > ${TMP}
	mv ${TMP} ${RAVEN_MIN}

test:
	./node_modules/.bin/jshint .
	./node_modules/.bin/phantomjs phantom-js-loader.js