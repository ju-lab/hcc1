#!/bin/bash
mkdir -p germline
germcall.sh -b bam/WG*/*.bam -e purecn/pon/target_bed/S04380110_SureSelectV5_DepthOfCoverage.patched.bed -l strelka freebayes manta -o germline -d 1
