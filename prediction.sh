#!/bin/bash

dims=32

for tbl in sms_data_and fb_posts_iph; do
	echo "$tbl classification"
	$HOME/dlatkInterface.py -d sms_fb -t $tbl -c user_id \
		-f "feat\$cat_met_a30_2000_cp_w\$$tbl\$user_id\$1gra" \
		--outcome_table baseline_matched --outcomes phq_depressed auditc_unhealthy perceived_stress_more_than_avg \
		--nfold_test_classifiers --stratify_folds --model lr --folds 10 \
		2>&1 | tee ${tbl}_topics_class.txt 
	$HOME/dlatkInterface.py -d sms_fb -t $tbl -c user_id \
		-f "feat\$dr_pca_roberta_ba_meL11con_pca\$$tbl\$user_id" \
		--outcome_table baseline_matched --outcomes phq_depressed auditc_unhealthy perceived_stress_more_than_avg \
		--nfold_test_classifiers --stratify_folds --model lr --folds 10 \
		2>&1 | tee ${tbl}_robertaDimRedCustom_class.txt 
	$HOME/dlatkInterface.py -d sms_fb -t $tbl -c user_id \
		-f "feat\$dr_rpca_roberta_ba_meL11con_pca_g\$$tbl\$user_id" \
		--outcome_table baseline_matched --outcomes phq_depressed auditc_unhealthy perceived_stress_more_than_avg \
		--nfold_test_classifiers --stratify_folds --model lr --folds 10 \
		2>&1 | tee ${tbl}_robertaDimRedGanesan_class.txt 
	$HOME/dlatkInterface.py -d sms_fb -t $tbl -c user_id \
		-f "feat\$roberta_ba_meL11con\$$tbl\$user_id" \
		--feat_selection k_pca --n_components $dims \
		--outcome_table baseline_matched --outcomes phq_depressed auditc_unhealthy perceived_stress_more_than_avg \
		--nfold_test_classifiers --stratify_folds --model lr --folds 10 \
		2>&1 | tee ${tbl}_robertaDimRedFeatSelection_class.txt 

	echo "$tbl regression"
	$HOME/dlatkInterface.py -d sms_fb -t $tbl -c user_id \
		-f "feat\$cat_met_a30_2000_cp_w\$$tbl\$user_id\$1gra" \
		--outcome_table baseline_matched --outcomes perceived_stress phq auditc \
		--nfold_test_regression --stratify_folds --model ridgefirstpasscv --folds 10 \
		2>&1 | tee ${tbl}_topics_regr.txt 
	$HOME/dlatkInterface.py -d sms_fb -t $tbl -c user_id \
		-f "feat\$dr_pca_roberta_ba_meL11con_pca\$$tbl\$user_id" \
		--outcome_table baseline_matched --outcomes perceived_stress phq auditc \
		--nfold_test_regression --stratify_folds --model ridgefirstpasscv --folds 10 \
		2>&1 | tee ${tbl}_robertaDimRedCustom_regr.txt 
	$HOME/dlatkInterface.py -d sms_fb -t $tbl -c user_id \
		-f "feat\$dr_rpca_roberta_ba_meL11con_pca_g\$$tbl\$user_id" \
		--outcome_table baseline_matched --outcomes perceived_stress phq auditc \
		--nfold_test_regression --stratify_folds --model ridgefirstpasscv --folds 10 \
		2>&1 | tee ${tbl}_robertaDimRedGanesan_regr.txt 
	$HOME/dlatkInterface.py -d sms_fb -t $tbl -c user_id \
		-f "feat\$roberta_ba_meL11con\$$tbl\$user_id" \
		--feat_selection k_pca --n_components $dims \
		--outcome_table baseline_matched --outcomes perceived_stress phq auditc \
		--nfold_test_regression --stratify_folds --model ridgefirstpasscv --folds 10 \
		2>&1 | tee ${tbl}_robertaDimRedFeatSelection_regr.txt 
done