#!/bin/bash
(
echo "# summary: grep antigen-garnish supporting allele names"
for i in hlareporter/*/results/*HLA_A*.out; do
	echo -en "$(basename $(dirname $(dirname $i)))\tHLA_A\t"
	results=($(sed -n 's/^\(A\*[0-9]*:[0-9]*\).*/\1/p' $i| sort | uniq| sed 's/\*/./g')) 
	for j in ${results[@]}; do
		echo "HLA-${j}"
		#sed -n "/-${j}/p" hlareporter/summary/all_alleles.txt
	done | tr '\n' ',' | sed 's/,$/\t/'
	for j in ${results[@]}; do
		#echo "HLA-${j}"
		sed -n "/-${j}/p" hlareporter/summary/all_alleles.txt
	done | tr '\n' ',' | sed 's/,$//'
	echo
done
for i in hlareporter/*/results/*HLA_B*.out; do
	echo -en "$(basename $(dirname $(dirname $i)))\tHLA_B\t"
	results=($(sed -n 's/^\(B\*[0-9]*:[0-9]*\).*/\1/p' $i| sort | uniq| sed 's/\*/./g')) 
	for j in ${results[@]}; do
		echo "HLA-${j}"
		#sed -n "/-${j}/p" hlareporter/summary/all_alleles.txt
	done | tr '\n' ',' | sed 's/,$/\t/'
	for j in ${results[@]}; do
		#echo "HLA-${j}"
		sed -n "/-${j}/p" hlareporter/summary/all_alleles.txt
	done | tr '\n' ',' | sed 's/,$//'
	echo
done
for i in hlareporter/*/results/*HLA_C*.out; do
	echo -en "$(basename $(dirname $(dirname $i)))\tHLA_C\t"
	results=($(sed -n 's/^\(C\*[0-9]*:[0-9]*\).*/\1/p' $i| sort | uniq| sed 's/\*/./g')) 
	for j in ${results[@]}; do
		echo "HLA-${j}"
		#sed -n "/-${j}/p" hlareporter/summary/all_alleles.txt
	done | tr '\n' ',' | sed 's/,$/\t/'
	for j in ${results[@]}; do
		#echo "HLA-${j}"
		sed -n "/-${j}/p" hlareporter/summary/all_alleles.txt
	done | tr '\n' ',' | sed 's/,$//'
	echo
done
for i in hlareporter/*/results/*HLA_DPB1*.out; do
	echo -en "$(basename $(dirname $(dirname $i)))\tHLA_DPB1\t"
	results=($(sed -n 's/^\(DPB1\*[0-9]*:[0-9]*\).*/\1/p' $i| sort | uniq)) 
	results2=($(sed -n 's/^\(DPB1\*[0-9]*:[0-9]*\).*/\1/p' $i| sort | uniq| sed 's/\*/./g;s/DPB1/DPB/;s/[0-9][0-9]$/0&/')) 
	for j in ${results[@]}; do
		echo "HLA-${j}"
		#sed -n "/-${j}/p" hlareporter/summary/all_alleles.txt
	done | tr '\n' ',' | sed 's/,$/\t/'
	for j in ${results2[@]}; do
		#echo "HLA-${j}"
		sed -n "/-${j}/p" hlareporter/summary/all_alleles.txt
	done | tr '\n' ',' | sed 's/,$//'
	echo
done
)
# > hlareporter/summary/summary.txt
