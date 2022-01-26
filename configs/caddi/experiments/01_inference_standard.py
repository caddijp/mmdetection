from mmdet.apis import init_detector, inference_detector
import mmcv
from pathlib import Path

# Specify the path to model config and checkpoint file
config_file = 'configs/faster_rcnn/faster_rcnn_r50_fpn_1x_coco.py'
checkpoint_file = 'checkpoints/faster_rcnn_r50_fpn_1x_coco_20200130-047c8118.pth'

# build the model from a config file and a checkpoint file
model = init_detector(config_file, checkpoint_file, device='cuda:0')

# img dir
img = "data/bkt-orama-anocci-prod/caddi/fy2022q1-200/images/target-001.png"

# test a single image and show the results
# img = 'test.jpg'  # or img = mmcv.imread(img), which will only load it once
img = 'data/coco/train2017/000000154452.jpg'
result = inference_detector(model, img)
# visualize the results in a new window
model.show_result(img, result)
# or save the visualization results to image files
model.show_result(img, result, out_file='result.jpg')

# test a video and show the results
# video = mmcv.VideoReader('video.mp4')
# for frame in video:
#     result = inference_detector(model, frame)
#     model.show_result(frame, result, wait_time=1)