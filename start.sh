#!/bin/bash
if [ -z "$REDIRECT_TARGET" ]; then
	echo "Redirect target variable not set (REDIRECT_TARGET)"
	exit 1
else
	# Add http if not set
	if ! [[ $REDIRECT_TARGET =~ ^https?:// ]]; then
		REDIRECT_TARGET="http://$REDIRECT_TARGET"
	fi
fi

# Default to 80
LISTEN="80"
# Listen to PORT variable given on Cloud Run Context
if [ ! -z "$PORT" ]; then
	LISTEN="$PORT"
fi

if [ -z "$REDIRECT_TYPE" ]; then
	TYPE="redirect"
elif [ "$REDIRECT_TYPE"="permanent" ]; then
	TYPE="permanent"
else
	TYPE="redirect"
fi

cat <<EOF > /etc/nginx/conf.d/default.conf
server {
	listen ${LISTEN};

	rewrite ^/(.*)\$ ${REDIRECT_TARGET}\$1 $MODE;
}
EOF


echo  -e "Listening: $LISTEN\nHTTP Redirect Destination: ${REDIRECT_TARGET}\nType: ${TYPE}"

exec nginx -g "daemon off;"
