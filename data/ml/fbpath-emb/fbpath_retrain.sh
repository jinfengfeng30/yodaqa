#!/bin/sh
# fbpath_retrain.sh - Retrain the freebase paths classifier from scratch
#
# Usage: fbpath_retrain.sh DATADIR
# Example: data/ml/fbpath-emb/fbpath_retrain.sh ../dataset-factoid-webquestions/
#
# Requires dataset-factoid-webquestions checkout and Sentence-selection checkout.
# Requires all relation generated by generate_relations.py script in data/ml/fbpath-emb/relations

set -e

datadir=$1

# First stage - training Mb concept matrix

rm -rf data/ml/fbpath-emb/props-webquestions-train
mkdir -p data/ml/fbpath-emb/props-webquestions-train/first
mkdir -p data/ml/fbpath-emb/props-webquestions-train/second
mkdir -p data/ml/fbpath-emb/props-webquestions-train/third
data/ml/fbpath-emb/fbpath_emb.py 1 "$datadir"/d-dump/trainmodel.json data/ml/fbpath-emb/relations/trainmodel.json "$datadir"/d-freebase-brp/trainmodel.json data/ml/fbpath-emb/props-webquestions-train/first
data/ml/fbpath-emb/fbpath_emb.py 2 "$datadir"/d-dump/trainmodel.json data/ml/fbpath-emb/relations2/trainmodel.json "$datadir"/d-freebase-brp/trainmodel.json data/ml/fbpath-emb/props-webquestions-train/second
data/ml/fbpath-emb/fbpath_emb.py 3 "$datadir"/d-dump/trainmodel.json data/ml/fbpath-emb/relations2/trainmodel.json "$datadir"/d-freebase-brp/trainmodel.json data/ml/fbpath-emb/props-webquestions-train/third

basedir=$(pwd)
cd ../Sentence-selection/
./std_run.sh -p "$basedir"/data/ml/fbpath-emb/props-webquestions-train/first
cp data/Mbtemp.txt "$basedir"/src/main/resources/cz/brmlab/yodaqa/analysis/rdf/Mbrel1.txt
cd "$basedir"

cd ../Sentence-selection/
./std_run.sh -p "$basedir"/data/ml/fbpath-emb/props-webquestions-train/second
cp data/Mbtemp.txt "$basedir"/src/main/resources/cz/brmlab/yodaqa/analysis/rdf/Mbrel2.txt
cd "$basedir"

cd ../Sentence-selection/
./std_run.sh -p "$basedir"/data/ml/fbpath-emb/props-webquestions-train/third
cp data/Mbtemp.txt "$basedir"/src/main/resources/cz/brmlab/yodaqa/analysis/rdf/Mbrel3.txt
cd "$basedir"
