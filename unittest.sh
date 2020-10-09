set -o errexit

LUA_BIN=$1
WORKSPACE=$2

chk_ret() {
	LUA_BIN=$1
	LUA_FILE=$2
	
	${LUA_BIN} ${LUA_FILE}
	retcode=$?
	if [ "${retcode}" -ne "0" ];then
		echo "Failed execute lua file : ${LUA_FILE}, retcode is ${retcode}"
		exit 1
	fi
}

# show the lua version
${LUA_BIN} -v

for LUA_FILE in $(find ${WORKSPACE} -type f -wholename "${WORKSPACE}/*.lua" -maxdepth 1)
do
	chk_ret ${LUA_BIN} ${LUA_FILE}
done
