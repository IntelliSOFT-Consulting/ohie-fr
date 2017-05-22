#!/bin/bash

${IL_HOST=localhost}

export IL_HOST

$CATALINA_HOME/bin/catalina.sh run &

sleep 150

curl "$IL_HOST:9000/api/dataStore/CSD-Loader-Last-Export/DHIS" -X POST -H "Content-Type: application/json" -d "{\"Facility Registry\":\"Sample Value\"}" -u admin:district -v

tail -F `find $CATALINA_HOME/logs/ -name "catalina*"`
