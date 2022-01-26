.PHONY: link-data

## link data
link-data:
	ln -s ~/data data

## checkpoints
get-checkpoints:
	wget -P checkpoints https://download.openmmlab.com/mmdetection/v2.0/mask_rcnn/mask_rcnn_r50_caffe_fpn_mstrain-poly_3x_coco/mask_rcnn_r50_caffe_fpn_mstrain-poly_3x_coco_bbox_mAP-0.408__segm_mAP-0.37_20200504_163245-42aa3d00.pth

## train annoci
train-annoci:
	python tools/train.py configs/caddi/experiments/03_annoci.py 	

## train balloon
train-balloon:
	python tools/train.py configs/caddi/experiments/02_coco_balloon.py
