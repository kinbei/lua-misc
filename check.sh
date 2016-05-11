# call from .travis/setup_lua.sh

$1 -v
find ${TRAVIS_BUILD_DIR} -type f -wholename "${TRAVIS_BUILD_DIR}/*.lua" -not -path "${TRAVIS_BUILD_DIR}/lua/*" -exec $1 {} \;
