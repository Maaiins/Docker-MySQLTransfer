#!/bin/sh
set -e

# ----
# Check env variables

echo "     _ _     _ _             _ _ "
echo "    |   \   /   |           (_)_)"
echo "    | |\ \ / /| | __ _  __ _ _ _ _  __   __"
echo "    | | \ _ / | |/ _\` |/ _\` | | | '_  \\/ __|"
echo "    | |       | | (_| | (_| | | | | | |\\__ \\"
echo "    |_|       |_|\__,_|\__,_|_|_|_| |_||__ /"
cat >&1 <<-EOT

----
Checking requirements...
----

EOT

# Source MYSQL
if [ -z ${MYSQL_SOURCE_ADDRESS} ]; then
    cat >&2 <<-EOT
		ERROR: you need to specify MYSQL_SOURCE_ADDRESS
	EOT
    exit 1
else
    cat >&1 <<-EOT
		OK: MYSQL_SOURCE_ADDRESS is given
	EOT
fi

if [ -z ${MYSQL_SOURCE_USER} ]; then
    cat >&2 <<-EOT
		ERROR: you need to specify MYSQL_SOURCE_USER
	EOT
    exit 1
else
    cat >&1 <<-EOT
		OK: MYSQL_SOURCE_USER is given
	EOT
fi

if [ -z ${MYSQL_SOURCE_PASSWORD} ]; then
    cat >&2 <<-EOT
		ERROR: you need to specify MYSQL_SOURCE_PASSWORD
	EOT
    exit 1
else
    cat >&1 <<-EOT
		OK: MYSQL_SOURCE_PASSWORD is given
	EOT
fi

if [ -z ${MYSQL_SOURCE_DATABASE} ]; then
    cat >&2 <<-EOT
		ERROR: you need to specify MYSQL_SOURCE_DATABASE
	EOT
    exit 1
else
    cat >&1 <<-EOT
		OK: MYSQL_SOURCE_DATABASE is given
	EOT
fi

# Target MYSQL
if [ -z ${MYSQL_TARGET_ADDRESS} ]; then
    cat >&2 <<-EOT
		ERROR: you need to specify MYSQL_TARGET_ADDRESS
	EOT
    exit 1
else
    cat >&1 <<-EOT
		OK: MYSQL_TARGET_ADDRESS is given
	EOT
fi

if [ -z ${MYSQL_TARGET_USER} ]; then
    cat >&2 <<-EOT
		ERROR: you need to specify MYSQL_TARGET_USER
	EOT
    exit 1
else
    cat >&1 <<-EOT
		OK: MYSQL_TARGET_USER is given
	EOT
fi

if [ -z ${MYSQL_TARGET_PASSWORD} ]; then
    cat >&2 <<-EOT
		ERROR: you need to specify MYSQL_TARGET_PASSWORD
	EOT
    exit 1
else
    cat >&1 <<-EOT
		OK: MYSQL_TARGET_PASSWORD is given
	EOT
fi

if [ -z ${MYSQL_TARGET_DATABASE} ]; then
    cat >&2 <<-EOT
		ERROR: you need to specify MYSQL_TARGET_DATABASE
	EOT
    exit 1
else
    cat >&1 <<-EOT
		OK: MYSQL_TARGET_DATABASE is given
	EOT
fi

# ----
# Set default values if not provided

# Source MYSQL
if [ -z ${MYSQL_SOURCE_PORT} ]; then
    cat >&1 <<-EOT
		INFO: MYSQL_SOURCE_PORT not set, default 3306
	EOT
    MYSQL_SOURCE_PORT=3306
fi

# Target MYSQL
if [ -z ${MYSQL_TARGET_PORT} ]; then
    cat >&1 <<-EOT
		INFO: MYSQL_TARGET_PORT not set, default 3306
	EOT
    MYSQL_TARGET_PORT=3306
fi

# Retention
if [ -z ${MYSQL_TRANSFER_RETENTION} ]; then
    cat >&1 <<-EOT
		INFO: MYSQL_TRANSFER_RETENTION not set, default 1d
	EOT
    MYSQL_TRANSFER_RETENTION=1d
fi

cat >&1 <<-EOT

----
Successfully checked requirements!
----
EOT

transfer ()
{
cat >&1 <<-EOT

----
Begin transaction $(date)
----

EOT

    mysqldump -v --user="${MYSQL_SOURCE_USER}" --password="${MYSQL_SOURCE_PASSWORD}" --host="${MYSQL_SOURCE_ADDRESS}" --port="${MYSQL_SOURCE_PORT}" --routines --triggers "${MYSQL_SOURCE_DATABASE}" | sed -e 's/DEFINER=[^*]*\*/\*/' | mysql -v --user="${MYSQL_TARGET_USER}" --password="${MYSQL_TARGET_PASSWORD}" --host="${MYSQL_TARGET_ADDRESS}" --port="${MYSQL_TARGET_PORT}" "${MYSQL_TARGET_DATABASE}"

cat >&1 <<-EOT

    ----
    End transaction $(date)
    ----
EOT
}

while true; do
    transfer
    if [ "${MYSQL_TRANSFER_RETENTION}" = false ] ; then
        break
    fi
    sleep ${MYSQL_TRANSFER_RETENTION}
done