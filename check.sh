# call from .travis/setup_lua.sh

check_retcode() {
	# $1 lua bin
	# $2 lua file name
	$1 $2
	retcode=$?
	echo "return code is ${retcode}"
	if [ "${retcode}" -ne "0" ];then
	   exit 1;
	fi
}

$1 -v
# -exec check_retcode $1 {} \;

for lua_file in $( find ${TRAVIS_BUILD_DIR} -type f -wholename "${TRAVIS_BUILD_DIR}/*.lua" -not -path "${TRAVIS_BUILD_DIR}/lua/*" )
do
	check_retcode $1 ${lua_file}
done
