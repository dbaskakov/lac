#!/bin/bash

for i in {1..5};
do
  sgdisk -n ${i}:0:+100M /dev/md/raid1
done