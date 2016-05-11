# call from .travis/setup_lua.sh

check_retcode() {
	# $1 lua bin
	# $2 lua file name
	$1 $2
	echo "return code is $?"
	if [ "$?" -ne "0" ];then
	   exit 1;
	fi
}

$1 -v
find ${TRAVIS_BUILD_DIR} -type f -wholename "${TRAVIS_BUILD_DIR}/*.lua" -not -path "${TRAVIS_BUILD_DIR}/lua/*" -exec check_retcode $1 {} \;
