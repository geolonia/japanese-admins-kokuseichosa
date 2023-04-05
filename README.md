# GeoJSON endpoints for Japanese administrations by 国勢調査境界データ

```
https://geolonia.github.io/japanese-admins-kokuseichosa/<prefCode>/<adminCode>.json
```

## ビルド方法

```
$ npm install
$ npm run build
```

## 備考

* [政府統計の総合窓口（e-Stat）境界データ 小地域町丁・字等）（JGD2011）](https://www.e-stat.go.jp/gis/statmap-search?page=1&type=2&aggregateUnitForBoundary=A&toukeiCode=00200521&toukeiYear=2020&serveyId=B002005212020&coordsys=1&format=shape&datum=2011)を加工して作成
* 政令指定都市は、区単位に分割してJSONファイルを作成しています。そのため JSON ファイルの数は、市区町村数（政令市、市、特別区、区、町、村） - 政令市数 となります。
