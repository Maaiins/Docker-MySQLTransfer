[![](https://img.shields.io/badge/license-AGPL%20v3-blue.svg)](https://github.com/Maaiins/Docker-MYSQLTransfer/blob/master/LICENSE 'Project Licence') [![](https://img.shields.io/docker/stars/maaiins/mysql-transfer.svg)](https://hub.docker.com/r/maaiins/mysql-transfer 'Project DockerHub') [![](https://img.shields.io/docker/pulls/maaiins/mysql-transfer.svg)](https://hub.docker.com/r/maaiins/mysql-transfer 'Project DockerHub')

# Docker-MySQLTransfer

### Usage

To run it:

    $ docker run \
          -e "MYSQL_SOURCE_ADDRESS=foo.bar" \
          -e "MYSQL_SOURCE_DATABASE=foo" \
          -e "MYSQL_SOURCE_PORT=3306" \ # Only needed if port is not 3306, will be set to 3306 if environment variable is not set
          -e "MYSQL_SOURCE_USER=user" \
          -e "MYSQL_SOURCE_PASSWORD=password" \
          -e "MYSQL_TARGET_ADDRESS=foo.bar" \
          -e "MYSQL_TARGET_DATABASE=bar" \ # Should not exist
          -e "MYSQL_TARGET_PORT=3306" \ # Only needed if port is not 3306, will be set to 3306 if environment variable is not set
          -e "MYSQL_TARGET_USER=user" \
          -e "MYSQL_TARGET_PASSWORD=password" \
          -v /foo/bar:/sql \ # Needed when you like to executes script on target or spurce database (source.sql or target.sql)
          maaiins/mysql-transfer