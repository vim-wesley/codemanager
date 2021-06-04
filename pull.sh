# add_core
# $1 - name
# $2 - DIRNAME
# return - void
create_core(){
	mkdir -p $CODE_MANAGER_DIR/$2
}

# create_alias
# $1 - name
# $2 - ALIAS_DIRNAME
# $3 - DIRNAME
# return - void
create_alias(){
	DIR=$CODE_MANAGER_DIR/$3/$2
	ALIAS_DIR=$CODE_MANAGER_DIR/$2
	mkdir -p $DIR
	ln -sf $DIR $ALIAS_DIR
}

# get_core
# $1 - name
# return - core name DIRNAME 
get_core(){
	cat ./default_languages | grep "^core $1 .*$"
}


# get_alias
# $1 - name
# return - core name DIRNAME 
get_alias(){
	cat ./default_languages | grep "^alias $1 .*$"
}

# check_core
# $1 - name
# return - status 
check_core(){
	CORE=$(get_core $1)
	if [ $(echo $CORE | wc -w) = '3' ]; then
		echo 0
	else
		echo 1
	fi		
}

# check_alias
# $1 - name
# return - status
check_alias(){
	ALIAS=$(get_alias $1)
	if [ $(echo $ALIAS | wc -w) = '4' ]; then
		echo 0
	else
		echo 1
	fi		
}

# pull
# $1 - name
pull(){
	CORE_STATUS=$(check_core $1)

	if [ $CORE_STATUS = '0' ]; then
		CORE=$(get_core $1)
		NAME=$(echo $CORE | awk '{ print $2 }')
		DIRNAME=$(echo $CORE | awk '{ print $3 }')
		create_core $NAME $DIRNAME
		echo "$DIRNAME was created"
		exit 0
	elif [ $(check_alias $1) = '0' ]; then
		ALIAS=$(get_alias $1)
		NAME=$(echo $ALIAS | awk '{ print $2 }')
		LINK=$(echo $ALIAS | awk '{ print $3 }')	
		DIRNAME=$(echo $ALIAS | awk '{ print $4 }')
		create_alias $NAME $LINK $DIRNAME
		exit 0
	fi
	echo "$1 was not found"
	exit 1	
}