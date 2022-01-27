# Object view ssd
面図認識(object-view)をSSD(object detection)で行うためのrepo.

## Using
- [mmdet](https://github.com/open-mmlab/mmdetection)
- [caddi-object-detection-tools](https://github.com/caddijp/object-detection-tools)

## Start with mmdet
mmdet は思想として、main repo を fork してその中で作業をするように
設計されている.
config, tools 等が学習を行うには不可欠だが、
パッケージ `mmdet` の中には含まれていないことから類推される.

## Inspiration from
- [Papers with code](https://paperswithcode.com/task/object-detection)
