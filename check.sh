# call from .travis/setup_lua.sh

$1 -v
find ./ -type f -wholename "${TRAVIS_BUILD_DIR}/*.lua" -exec $1 {} +

$1 ${TRAVIS_BUILD_DIR}/trace_log.lua