#!/bin/bash

if false; then

# 1-2k words/phrases

$HOME/dlatkInterface.py -d sms_fb -t sms_data -c user_id \
	-f 'feat$1gram$sms_data_and$user_id$0_05' --group_freq_thresh 500 \
	--correlate --tagcloud --make_wordclouds \
	--outcome_table baseline_matched --outcomes phq perceived_stress auditc \
	--output sms_corr --csv --rmatrix --sort
$HOME/dlatkInterface.py -d sms_fb -t fb_posts -c user_id \
	-f 'feat$1gram$fb_posts_iph$user_id$0_05' --group_freq_thresh 500 \
	--correlate --tagcloud --make_wordclouds \
	--outcome_table baseline_matched --outcomes phq perceived_stress auditc \
	--output fb_corr --csv --rmatrix --sort

fi

$HOME/dlatkInterface.py -d sms_fb -t sms_data -c user_id \
	-f 'feat$cat_met_a30_2000_cp_w$sms_data_and$user_id$1gra' --group_freq_thresh 500 \
	--correlate --topic_tagcloud --make_topic_wordclouds --topic_lexicon met_a30_2000_freq_t50ll \
	--outcome_table baseline_matched --outcomes phq perceived_stress auditc \
	--output sms_corr_topics --csv --rmatrix --sort
$HOME/dlatkInterface.py -d sms_fb -t fb_posts -c user_id \
	-f 'feat$cat_met_a30_2000_cp_w$fb_posts_iph$user_id$1gra' --group_freq_thresh 500 \
	--correlate --topic_tagcloud --make_topic_wordclouds --topic_lexicon met_a30_2000_freq_t50ll \
	--outcome_table baseline_matched --outcomes phq perceived_stress auditc \
	--output fb_corr_topics --csv --rmatrix --sort