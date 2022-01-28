.PHONY: link-data get-checkpoints train-annci train-balloon sync loss-plots
.PHONY: topk test sync-work test-leaky

## link data
link-data:
	ln -s ~/data data

## checkpoints
get-checkpoints:
	wget -P checkpoints https://download.openmmlab.com/mmdetection/v2.0/mask_rcnn/mask_rcnn_r50_caffe_fpn_mstrain-poly_3x_coco/mask_rcnn_r50_caffe_fpn_mstrain-poly_3x_coco_bbox_mAP-0.408__segm_mAP-0.37_20200504_163245-42aa3d00.pth

## train balloon (from tutorial)
train-balloon:
	python tools/train.py configs/caddi/experiments/02_coco_balloon.py

## sync working dir to gs
sync:
	# gsutil -m cp -r 0127 gs://shota-dev/bkt-orama-anocci-prod/caddi/fy2022q1-200/
	gsutil -m cp -r "./results " gs://shota-dev/bkt-orama-anocci-prod/caddi/fy2022q1-200/results

## train annoci (ours)
train-annoci:
	# python tools/train.py configs/caddi/experiments/03_annoci.py 	
	python tools/train.py configs/caddi/experiments/04_annoci_with_split.py

## test and get results.pkl
test:
	python "./tools/test.py" \
		"./configs/caddi/experiments/04_annoci_with_split.py" \
		"./work_dirs/04_annoci_with_split/latest.pth" \
		--show \
		--out "./results/04_annoci_with_split/result__latest.pkl"

## make leaky results (to check that train/test/val is working)
test-leaky:
	python "./tools/test.py" \
		"./configs/caddi/experiments/05_annoci_with_split_check_no_leak.py" \
		"./work_dirs/04_annoci_with_split/latest.pth" \
		--show \
		--out "./results/05_annoci_with_split_check_no_leak/result__latest.pkl"

## make loss plots
loss-plots:
	python tools/analysis_tools/analyze_logs.py plot_curve \
		work_dirs/04_annoci_with_split/20220127_104043.log.json \
		--keys loss_cls loss_bbox \
		--out outputs/losses.png

## result analysis (topk best and worst results)
topk:
	python "./tools/analysis_tools/analyze_results.py" \
		"./configs/caddi/experiments/04_annoci_with_split.py" \
		"./results/04_annoci_with_split/result__latest.pkl" \
		"./results/04_annoci_with_split/topk" \
    	--show

## result analysis (leaky one)
topk-leaky:
	python "./tools/analysis_tools/analyze_results.py" \
		"./configs/caddi/experiments/05_annoci_with_split_check_no_leak.py" \
		"./results/05_annoci_with_split_check_no_leak/result__latest.pkl" \
		"./results/05_annoci_with_split_check_no_leak/topk" \
    	--show

.PHONY: browse
## browse dataset
browse:
	python tools/misc/browse_dataset.py \
		"./configs/caddi/experiments/04_annoci_with_split.py"

############################################################################
# Self Documenting Commands     
############################################################################

.DEFAULT_GOAL := help


# Inspired by <http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html>
# sed script explained:
# /^##/:
# 	* save line in hold space
# 	* purge line
# 	* Loop:
# 		* append newline + line to hold space
# 		* go to next line
# 		* if line starts with doc comment, strip comment character off and loop
# 	* remove target prerequisites
# 	* append hold space (+ newline) to line
# 	* replace newline plus comments by `---`
# 	* print line
# Separate expressions are necessary because labels cannot be delimited by
# semicolon; see <http://stackoverflow.com/a/11799865/1968>
.PHONY: help
help:
	@echo "$$(tput bold)Available rules:$$(tput sgr0)"
	@echo
	@sed -n -e "/^## / { \
		h; \
		s/.*//; \
		:doc" \
		-e "H; \
		n; \
		s/^## //; \
		t doc" \
		-e "s/:.*//; \
		G; \
		s/\\n## /---/; \
		s/\\n/ /g; \
		p; \
	}" ${MAKEFILE_LIST} \
	| LC_ALL='C' sort --ignore-case \
	| awk -F '---' \
		-v ncol=$$(tput cols) \
		-v indent=19 \
		-v col_on="$$(tput setaf 6)" \
		-v col_off="$$(tput sgr0)" \
	'{ \
		printf "%s%*s%s ", col_on, -indent, $$1, col_off; \
		n = split($$2, words, " "); \
		line_length = ncol - indent; \
		for (i = 1; i <= n; i++) { \
			line_length -= length(words[i]) + 1; \
			if (line_length <= 0) { \
				line_length = ncol - indent - length(words[i]) - 1; \
				printf "\n%*s ", -indent, " "; \
			} \
			printf "%s ", words[i]; \
		} \
		printf "\n"; \
	}' \
	| more $(shell test $(shell uname) = Darwin && echo '--no-init --raw-control-chars')