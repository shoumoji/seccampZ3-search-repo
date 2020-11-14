#!/bin/bash

for ((page=1; page<=10; page++))
do
    curl -H \
        'Accept: application/vnd.github.preview.text-match+json' \
        "https://api.github.com/search/repositories?q=page:${page}&language:javascript&filename=package.json&order=desc" \
        >> data.json
done

jq .items[].html_url < data.json > repos.json
