#!/usr/bin/env bash
curl "https://api.vultr.com/v2/domains/{dns-domain}/records/{record-id}}" \
  -X PATCH \
  -H "Authorization: Bearer ${VULTR_API_KEY}" \
  -H "Content-Type: application/json" \
  --data '{
    "name" : "CNAME",
    "data" : "foo.example.com",
    "ttl" : 300,
    "priority" : 0
  }'
