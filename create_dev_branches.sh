#!/usr/bin/env bash

master=dev-master-66
dotcom=dev-dotcom-3

old_master=dev-master-65
old_dotcom=dev-dotcom-2

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
  git checkout -b $master
  git push
  git push -d origin $old_master
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
  git push -d origin $old_dotcom
  cd ..;
done
