#!/bin/bash
set -eu

if [ -e data.json ]; then
    rm data.json
fi

for ((page=1; page<=3; page++))
do
    curl -H \
        'Accept: application/vnd.github.preview.text-match+json' \
        "https://api.github.com/search/repositories?q=page:${page}&language:javascript&filename=package.json&order=desc" \
        >> data.json
done

jq .items[].html_url < data.json > repos.json
jq .items[].default_branch < data.json > branchs.json

paste repos.json branchs.json > raw_archive_url
sed -r 's/^\"(.*?)\".*?\"(.*?)\"$/\1\/archive\/\2.zip/g' < raw_archive_url > archive_url

rm repos.json branchs.json raw_archive_url data.json

# change directory -> projects/
if [ -d projects ]; then
    cd projects
    rm -rf *
else
    mkdir projects
    cd projects
fi

while read line
do
    # todo: ファイル名いい感じにする
    FILENAME=
    curl -O $line -o $NAME
done < ../archive_url

unzip *