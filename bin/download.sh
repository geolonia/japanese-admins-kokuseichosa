#!/usr/bin/env bash

set -e

url_template="https://www.e-stat.go.jp/gis/statmap-search/data?dlserveyId=A002005212020&code={code}&coordSys=1&format=shape&downloadType=5&datum=2011"
output_dir="data"

mkdir -p $output_dir

for i in {01..47}; do
  code=$(printf "%02d" $i)
  url=${url_template//\{code\}/$code}
  output_path="$output_dir/$code.zip"
  echo "Downloading: $code..."
  curl -o $output_path -L $url
  echo "Downloaded: $code"
  unzip -o $output_path -d $output_dir/$code
  ogr2ogr -f GeoJSON $output_dir/$code.geojson $output_dir/$code/r2ka$code.shp
  rm -rf $output_dir/$code
  rm $output_dir/$code.zip
done

echo "All prefecture boundaries downloaded."
