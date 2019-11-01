#!/bin/bash
#功能描述(Description):continue基本语法演示.

for i in 1 2
do
   echo $i
   for j in a b
   do
       echo $j
   done
done
echo "---"
for i in 1 2
do
   echo $i
   for j in a b
   do
       [ $j == a ] && continue
       echo $j
   done
done
echo "---"
for i in 1 2
do
   echo $i
   for j in a b
   do
       [ $j == a ] && continue 2
       echo $j
   done
done
