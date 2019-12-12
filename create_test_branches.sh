#!/usr/bin/env bash

master=master-test-1
dotcom=dotcom-test-1


for i in shop zest caramel brain magpie kit; do
  cd $i
  git fetch &>/dev/null;
  cd ..
done

echo "--MASTER--"
for i in shop zest caramel brain magpie kit; do
  cd $i;
  echo $i;
  git co master;
  git pull origin master
  git checkout -b $master || git checkout $master
  git push
  cd ..
done

echo "--DOTCOM--"
for i in shop zest; do
  cd $i
  echo $i
  git co dotcom
  git pull origin dotcom
  git checkout -b $dotcom
  git push
  cd ..;
done
