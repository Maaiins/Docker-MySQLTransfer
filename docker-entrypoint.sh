#!/bin/sh
set -e

stdout () {
cat >&1 <<-EOT
${1}
EOT
}

stderr () {
cat >&2 <<-EOT
${1}
EOT
}

exists () {
if [ -z ${1} ]; then
    # ----
    stderr "ERROR: you need to set ${2}"
    # ----

    exit 1
else
    # ----
    stdout "OK: ${2} set"
    # ----
fi
}


echo "     _ _     _ _             _ _ "
echo "    |   \   /   |           (_)_)"
echo "    | |\ \ / /| | __ _  __ _ _ _ _  __   __"
echo "    | | \ _ / | |/ _\` |/ _\` | | | '_  \\/ __|"
echo "    | |       | | (_| | (_| | | | | | |\\__ \\"
echo "    |_|       |_|\__,_|\__,_|_|_|_| |_||__ /"

# ----
stdout "Checking requirements..."
# ----

exists ${MYSQL_SOURCE_ADDRESS} "MYSQL_SOURCE_ADDRESS"
exists ${MYSQL_SOURCE_USER} "MYSQL_SOURCE_USER"
exists ${MYSQL_SOURCE_PASSWORD} "MYSQL_SOURCE_PASSWORD"
exists ${MYSQL_SOURCE_DATABASE} "MYSQL_SOURCE_DATABASE"
exists ${MYSQL_TARGET_ADDRESS} "MYSQL_TARGET_ADDRESS"
exists ${MYSQL_TARGET_USER} "MYSQL_TARGET_USER"
exists ${MYSQL_TARGET_PASSWORD} "MYSQL_TARGET_PASSWORD"
exists ${MYSQL_TARGET_DATABASE} "MYSQL_TARGET_DATABASE"

if [ -z ${MYSQL_SOURCE_PORT} ]; then
    # ----
	stdout "INFO: MYSQL_SOURCE_PORT not set, default 3306"
	# ----

    MYSQL_SOURCE_PORT=3306
fi

if [ -z ${MYSQL_TARGET_PORT} ]; then
    # ----
	stdout "INFO: MYSQL_TARGET_PORT not set, default 3306"
	# ----

    MYSQL_TARGET_PORT=3306
fi

# ----
stdout "Successfully checked requirements!"
# ----

# ----
stdout "Begin transaction $(date)"
# ----

mysqldump -v --user="${MYSQL_SOURCE_USER}" --password="${MYSQL_SOURCE_PASSWORD}" --host="${MYSQL_SOURCE_ADDRESS}" --port="${MYSQL_SOURCE_PORT}" --routines --triggers "${MYSQL_SOURCE_DATABASE}" | sed -e 's/DEFINER=[^*]*\*/\*/' | mysql -v --user="${MYSQL_TARGET_USER}" --password="${MYSQL_TARGET_PASSWORD}" --host="${MYSQL_TARGET_ADDRESS}" --port="${MYSQL_TARGET_PORT}" "${MYSQL_TARGET_DATABASE}"

cd /sql
ls -a >&1

if [ -e /sql/source.sql ]; then
    # ----
	stdout "Execute script on source"
	# ----

    mysql -v --user="${MYSQL_SOURCE_USER}" --password="${MYSQL_SOURCE_PASSWORD}" --host="${MYSQL_SOURCE_ADDRESS}" --port="${MYSQL_SOURCE_PORT}" "${MYSQL_SOURCE_DATABASE}" < /sql/source.sql
else
    # ----
	stdout "INFO: no script for execution on source shared"
	# ----
fi

if [ -e /sql/target.sql ]; then
    # ----
	stdout "Execute script on target"
	# ----

    mysql -v --user="${MYSQL_TARGET_USER}" --password="${MYSQL_TARGET_PASSWORD}" --host="${MYSQL_TARGET_ADDRESS}" --port="${MYSQL_TARGET_PORT}" "${MYSQL_TARGET_DATABASE}" < /sql/target.sql
else
    # ----
	stdout "INFO: no script for execution on target shared"
	# ----
fi

# ----
stdout "End transaction $(date)"
# ----