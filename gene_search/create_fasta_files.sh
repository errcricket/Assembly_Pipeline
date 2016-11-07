#!/bin/bash

python separate_regions.py

mkdir -p data
cd data/

python ../extract_phage_regions.py EDL933_phage_region_1.txt CP008957.gbk
python ../extract_phage_regions.py EDL933_phage_region_10.txt CP008957.gbk
python ../extract_phage_regions.py EDL933_phage_region_11.txt CP008957.gbk
python ../extract_phage_regions.py EDL933_phage_region_12.txt CP008957.gbk
python ../extract_phage_regions.py EDL933_phage_region_13.txt CP008957.gbk
python ../extract_phage_regions.py EDL933_phage_region_14.txt CP008957.gbk
python ../extract_phage_regions.py EDL933_phage_region_15.txt CP008957.gbk
python ../extract_phage_regions.py EDL933_phage_region_16.txt CP008957.gbk
python ../extract_phage_regions.py EDL933_phage_region_17.txt CP008957.gbk
python ../extract_phage_regions.py EDL933_phage_region_18.txt CP008957.gbk
python ../extract_phage_regions.py EDL933_phage_region_2.txt CP008957.gbk
python ../extract_phage_regions.py EDL933_phage_region_3.txt CP008957.gbk
python ../extract_phage_regions.py EDL933_phage_region_4.txt CP008957.gbk
python ../extract_phage_regions.py EDL933_phage_region_5.txt CP008957.gbk
python ../extract_phage_regions.py EDL933_phage_region_6.txt CP008957.gbk
python ../extract_phage_regions.py EDL933_phage_region_7.txt CP008957.gbk
python ../extract_phage_regions.py EDL933_phage_region_8.txt CP008957.gbk
python ../extract_phage_regions.py EDL933_phage_region_9.txt CP008957.gbk

cd -
