# call from .travis/setup_lua.sh

LUA_BIN=$1

check_retcode() {
	LUA_BIN=$1
	LUA_FILE=$2

	${LUA_BIN} ${LUA_FILE}
	$1 $2
	retcode=$?
	if [ "${retcode}" -ne "0" ];then
		echo "Failed execute lua file : ${LUA_FILE}, retcode is ${retcode}"
		exit 1;
	fi
}

# show the lua version
${LUA_BIN} -v

for LUA_FILE in $( find ${TRAVIS_BUILD_DIR} -type f -wholename "${TRAVIS_BUILD_DIR}/*.lua" -not -path "${TRAVIS_BUILD_DIR}/lua/*" )
do
	check_retcode ${LUA_BIN} ${LUA_FILE}
done
