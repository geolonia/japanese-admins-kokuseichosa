#!/usr/bin/env node

const path = require('path');
const fs = require('fs');
const readline = require('readline');
const glob = require("glob")

const files = glob.sync(`./data/*.geojson`);

for (const file of files) {
  const readStream = fs.createReadStream(file);
  const rl = readline.createInterface({
    input: readStream,
    crlfDelay: Infinity
  });

  let jsonBuffer = '';

  const data = {};

  rl.on('line', (line) => {
    jsonBuffer += line;
  }).on('close', () => {
    const geojson = JSON.parse(jsonBuffer);
    const features = geojson.features;

    features.forEach((feature) => {
      try {
        const prefCode = feature.properties.PREF.substr(0, 2);
        const adminCode = `${prefCode}${feature.properties.CITY}`;

        if (!data[prefCode]) {
          data[prefCode] = {};
        }

        if (!data[prefCode][adminCode]) {
          data[prefCode][adminCode] = {
            features: []
          };
        }

        data[prefCode][adminCode].features.push({
          type: 'Feature',
          properties: { name: `${feature.properties['PREF_NAME']}${feature.properties['CITY_NAME'] || ''}` },
          geometry: feature.geometry
        });
      } catch (e) {
      }
    });

    for (const pref in data) {
      const dir = path.join(path.dirname(path.dirname(__filename)), 'docs', pref);
      fs.mkdirSync(dir, { recursive: true });

      for (const admin in data[pref]) {
        const file = path.join(path.dirname(path.dirname(__filename)), 'docs', pref, `${admin}.json`);

        const newjson = {
          type: "FeatureCollection",
          features: data[pref][admin].features
        };

        fs.writeFileSync(file, JSON.stringify(newjson));
      }
    }
  });
}
