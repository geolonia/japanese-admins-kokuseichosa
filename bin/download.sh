#!/usr/bin/env bash

set -e
url_template="https://www.e-stat.go.jp/gis/statmap-search/data?dlserveyId=B002005212020&code={code}&coordSys=1&format=shape&downloadType=5&datum=2011"
output_dir="data"
script_dir=$(cd $(dirname $0); pwd)

mkdir -p $output_dir

tail -n +2 $script_dir/admin-code.csv | while read line; do
  code=$(echo $line | cut -d, -f1)
  echo $code
  url=${url_template//\{code\}/$code}
  output_path="$output_dir/$code.zip"
  echo "Downloading: $code..."
  curl -o $output_path -L $url
  echo "Downloaded: $code"
  unzip -o $output_path -d $output_dir/$code
  ogr2ogr -f GeoJSON $output_dir/$code.geojson $output_dir/$code/r2kb$code.shp
  rm -rf $output_dir/$code
  rm $output_dir/$code.zip
done
