"""
Same as 04
make the test data the same as training data
if the results are super good (as they should be) we can be confident that
that no leak happend (if it was in train it should be better)
"""
# The new config inherits a base config to highlight the necessary modification
_base_ = "../../mask_rcnn/mask_rcnn_r50_caffe_fpn_mstrain-poly_1x_coco.py"

# We also need to change the num_classes in head to match the dataset's annotation
model = dict(roi_head=dict(bbox_head=dict(num_classes=1), mask_head=dict(
    num_classes=1)))

img_prefix = "data/bkt-orama-anocci-prod/caddi/fy2022q1-200/"

# Modify dataset related settings
# dataset_type = "annoci"
dataset_type = "COCODataset"
classes = ("Object View",)
data = dict(
    train=dict(
        img_prefix=img_prefix + "images/",
        classes=classes,
        ann_file=img_prefix + "0127/train/annotation.json",
    ),
    val=dict(
        img_prefix=img_prefix + "images/",
        classes=classes,
        ann_file=img_prefix + "0127/val/annotation.json",
    ),
    test=dict(
        img_prefix=img_prefix + "images/",
        classes=classes,
        # ann_file=img_prefix + "0127/test/annotation.json",
        ann_file=img_prefix + "0127/train/annotation.json",  # use train for test data
    ),
)

# We can use the pre-trained Mask RCNN model to obtain higher performance
load_from = "checkpoints/mask_rcnn_r50_caffe_fpn_mstrain-poly_3x_coco_bbox_mAP-0.408__segm_mAP-0.37_20200504_163245-42aa3d00.pth"
