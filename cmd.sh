#!/bin/bash

: ${SERVER_ADDRESS=localhost}
: ${DHIS_ADMIN_PASSWORD=district}

export SERVER_ADDRESS
export DHIS_ADMIN_PASSWORD

$CATALINA_HOME/bin/catalina.sh run &

sleep 60

curl "$SERVER_ADDRESS:9000/api/dataStore/CSD-Loader-Last-Export/DHIS" -X POST -H "Content-Type: application/json" -d "{\"Facility Registry\":\"Sample Value\"}" -u admin:${DHIS_ADMIN_PASSWORD} -v

tail -F `find $CATALINA_HOME/logs/ -name "catalina*"`
