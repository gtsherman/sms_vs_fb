#!/bin/bash

dims=32
dimred_model="pca"


if false; then

# Ngrams
$HOME/dlatkInterface.py -d sms_fb -t sms_data_and -c user_id --add_ngrams -n 1 2 3 --combine_feat_tables 1to3gram
$HOME/dlatkInterface.py -d sms_fb -t fb_posts_iph -c user_id --add_ngrams -n 1 2 3 --combine_feat_tables 1to3gram
$HOME/dlatkInterface.py -d sms_fb -t sms_data_and -c user_id -f 'feat$1gram$sms_data_and$user_id' --feat_occ_filter --set_p_occ 0.5
$HOME/dlatkInterface.py -d sms_fb -t fb_posts_iph -c user_id -f 'feat$1gram$fb_posts_iph$user_id' --feat_occ_filter --set_p_occ 0.5

# LIWC
$HOME/dlatkInterface.py -d sms_fb -t sms_data_and -c user_id --add_lex_table -l LIWC2015
$HOME/dlatkInterface.py -d sms_fb -t fb_posts_iph -c user_id --add_lex_table -l LIWC2015

# Topics
$HOME/dlatkInterface.py -d sms_fb -t sms_data_and -c user_id --add_lex_table -l met_a30_2000_cp --weighted_lexicon
$HOME/dlatkInterface.py -d sms_fb -t fb_posts_iph -c user_id --add_lex_table -l met_a30_2000_cp --weighted_lexicon

# Sentence tokenization
$HOME/dlatkInterface.py -d sms_fb -t sms_data_and -c user_id --add_sent_tokenized
$HOME/dlatkInterface.py -d sms_fb -t fb_posts_iph -c user_id --add_sent_tokenized

# New topics
$HOME/dlatkInterface.py -d sms_fb -t sms_data_and -c user_id \
	-f 'feat$1gram$sms_data_and$user_id' \
	--estimate_lda_topics --mallet_path ~/mallet-2.0.6/bin/mallet --num_lda_threads 60 \
	--lda_lexicon_name sms_300 \
	--num_topics 300
$HOME/dlatkInterface.py -d sms_fb -t fb_posts_iph -c user_id \
	-f 'feat$1gram$fb_posts_iph$user_id' \
	--estimate_lda_topics --mallet_path ~/mallet-2.0.6/bin/mallet --num_lda_threads 60 \
	--lda_lexicon_name fb_300 \
	--num_topics 300

# Roberta
CUDA_VISIBLE_DEVICES=0 $HOME/dlatkInterface.py -d sms_fb -t sms_data_and -c user_id \
	--add_embedding --emb_model roberta-base \
	--word_aggregation mean \
	--emb_layers 11 --emb_msg_aggregation mean \
	--batch_size 45
CUDA_VISIBLE_DEVICES=0 $HOME/dlatkInterface.py -d sms_fb -t fb_posts_iph -c user_id \
	--add_embedding --emb_model roberta-base \
	--word_aggregation mean \
	--emb_layers 11 --emb_msg_aggregation mean \
	--batch_size 45

fi

# Roberta dimensionally reduced
## Train custom
$HOME/dlatkInterface.py -d sms_fb -t sms_data_and -c user_id \
	-f 'feat$roberta_ba_meL11con$sms_data_and$user_id' \
	--model $dimred_model \
	--fit_reducer --n_components $dims \
	--save_model --picklefile dimred_roberta_sms_${dims}.pickle
$HOME/dlatkInterface.py -d sms_fb -t fb_posts_iph -c user_id \
	-f 'feat$roberta_ba_meL11con$fb_posts_iph$user_id' \
	--model $dimred_model \
	--fit_reducer --n_components ${dims} \
	--save_model --picklefile dimred_roberta_fb_${dims}.pickle
## Apply custom and pretrained
$HOME/dlatkInterface.py -d sms_fb -t sms_data_and -c user_id  \
	-f 'feat$roberta_ba_meL11con$sms_data_and$user_id' \
	--transform_to_feats 'roberta_ba_meL11con_pca' \
	--load --picklefile dimred_roberta_sms_${dims}.pickle
$HOME/dlatkInterface.py -d sms_fb -t fb_posts_iph -c user_id  \
	-f 'feat$roberta_ba_meL11con$fb_posts_iph$user_id' \
	--transform_to_feats 'roberta_ba_meL11con_pca' \
	--load --picklefile dimred_roberta_fb_${dims}.pickle
$HOME/dlatkInterface.py -d sms_fb -t sms_data_and -c user_id  \
	-f 'feat$roberta_ba_meL11con$sms_data_and$user_id' \
	--transform_to_feats 'roberta_ba_meL11con_pca_g' \
	--load --picklefile rpca_roberta_${dims}_D_20.pickle
$HOME/dlatkInterface.py -d sms_fb -t fb_posts_iph -c user_id  \
	-f 'feat$roberta_ba_meL11con$fb_posts_iph$user_id' \
	--transform_to_feats 'roberta_ba_meL11con_pca_g' \
	--load --picklefile rpca_roberta_${dims}_D_20.pickle

if false; then

# Twitter-roberta
CUDA_VISIBLE_DEVICES=0 $HOME/dlatkInterface.py -d sms_fb -t sms_data_and -c user_id \
	--add_embedding --emb_model 'cardiffnlp/twitter-roberta-base' --emb_class Roberta \
	--word_aggregation mean \
	--emb_layers 11 --emb_msg_aggregation mean \
	--batch_size 45
CUDA_VISIBLE_DEVICES=0 $HOME/dlatkInterface.py -d sms_fb -t fb_posts_iph -c user_id \
	--add_embedding --emb_model 'cardiffnlp/twitter-roberta-base' --emb_class Roberta \
	--word_aggregation mean \
	--emb_layers 11 --emb_msg_aggregation mean \
	--batch_size 45

fi