#!/bin/bash

: ${MYSQL_HOST=openmrs-mysql-db}
: ${MYSQL_ROOT_PASSWORD=secret_password}

export MYSQL_HOST
export MYSQL_ROOT_PASSWORD

USERNAME=admin;
POST_TEMPLATE=$(cat /postTemplate.json)
POST_TEMPLATE_NO_PERIODS=$(cat /postTemplateNoPeriods.json)

processFile() {
   REPORT_CONTENT=$(envsubst "`printf '${%s} ' $(bash -c "compgen -A variable")`"  < $1)
   REPORT_CONTENT="${REPORT_CONTENT//\"/\\\"}"
   REPORT_CONTENT=$(echo "$REPORT_CONTENT" | sed -E ':a;N;$!ba;s/\r{0,1}\n/\\n/g')
   REPORT_CONTENT=$(echo "$REPORT_CONTENT" | sed 's/\t/     /g')
   REPORT_NAME=$(echo $2 | sed 's/\([A-Z][^A-Z]\)/ \1/g')

   POST_CONTENT=$(printf "$3" "$REPORT_NAME" "$REPORT_CONTENT")
   echo "$POST_CONTENT" > tmp_report_content.json

   curl -X POST -H "Content-Type: application/json" -u "$USERNAME:$DHIS_ADMIN_PASSWORD" \
   "http://localhost:8080/api/reports" -d @tmp_report_content.json

   rm tmp_report_content.json
}

for file in /reports/*; do
  filename=$(basename "$file")
  fname="${filename%.*}"
  if [[ -f $file ]]; then
  processFile $file $fname "$POST_TEMPLATE"
  fi
done

for file in /reports/noPeriods/*; do
  filename=$(basename "$file")
  fname="${filename%.*}"
  if [[ -f $file ]]; then
  processFile $file $fname "$POST_TEMPLATE_NO_PERIODS"
  fi
done
