#!/bin/bash
YEAR=2019 # changeme!
#-----------------------------------------------
# Batter the Envr Canada radar image service to get an entire year worth of Radar images (from King city radar near Toronto)
#
# Rather than connecting repeatedly, you can pass a config file to curl with all the work to do (see curl -K). This keeps the connection open
# This script builds that config file then executes curl with it.
#
# A given year has about 52500 images at 10 minute intervals.
# This script runs 50 pulls at a time in parallel and still takes about 2 hrs.
###############################################
CFG=/tmp/cfg.txt
OUTDIR=/tmp/radar
YSTRING=$YEAR # initial value

rm $CFG
mkdir -p $OUTDIR
echo -e "[*]\tpreparing config file..."
i=0
while [ $i -lt 60000 ] && [ "${YSTRING:0:4}" == "$YEAR" ]; do
  step=$(( $i * 10 ))
  YSTRING=$(date -u -d "Jan 01 $YEAR 00:00 -0000 +${step} minutes" +%Y%m%d%H%M)
  i=$(( $i + 1 ))
  if [ "${YSTRING:0:4}" == "$YEAR" ]; then
    echo -e "output = \"${OUTDIR}/${YSTRING}.gif\"\nurl = \"https://climate.weather.gc.ca/radar/image_e.html?time=${YSTRING}&site=CASKR&image_type=COMP_PRECIPET_RAIN_WEATHEROFFICE\"" >> $CFG
  fi
done
echo -e "[*]\tfound $i images to download"
curl -Z -K $CFG
