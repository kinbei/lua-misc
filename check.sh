# call from .travis/setup_lua.sh

check_retcode() {
	[[ $1 -ne 0 ]] && exit 1
}

$1 -v
find ${TRAVIS_BUILD_DIR} -type f -wholename "${TRAVIS_BUILD_DIR}/*.lua" -not -path "${TRAVIS_BUILD_DIR}/lua/*" -exec $1 {} && check_retcode $? \;
