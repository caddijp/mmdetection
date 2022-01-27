"""try running annoci on pre-trained data

no train/test/val split, just train on all data
-> if loss is improving, there will definitly be an improvement

As the train/test/val split needs to be done on the annotation data too,
take care of that later.
"""
# The new config inherits a base config to highlight the necessary modification
_base_ = "../../mask_rcnn/mask_rcnn_r50_caffe_fpn_mstrain-poly_1x_coco.py"

# We also need to change the num_classes in head to match the dataset's annotation
model = dict(roi_head=dict(bbox_head=dict(num_classes=1), mask_head=dict(
    num_classes=1)))

img_prefix = "data/bkt-orama-anocci-prod/caddi/fy2022q1-200/0127/"

# Modify dataset related settings
# dataset_type = "annoci"
dataset_type = "COCODataset"
classes = ("object",)
data = dict(
    train=dict(
        img_prefix=img_prefix + "train/images/",
        classes=classes,
        ann_file=img_prefix + "train/annotation.json",
    ),
    val=dict(
        img_prefix=img_prefix + "val/images/",
        classes=classes,
        ann_file=img_prefix + "val/annotation.json",
    ),
    test=dict(
        img_prefix=img_prefix + "test/images/",
        classes=classes,
        ann_file=img_prefix + "test/annotation.json",
    ),
)

# We can use the pre-trained Mask RCNN model to obtain higher performance
load_from = "checkpoints/mask_rcnn_r50_caffe_fpn_mstrain-poly_3x_coco_bbox_mAP-0.408__segm_mAP-0.37_20200504_163245-42aa3d00.pth"
