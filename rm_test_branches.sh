#!/usr/bin/env bash

master_branch=release-master-1.23.4
dotcom_branch=release-dotcom-1.23.4


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
  git push --delete origin $master_branch
  git branch -D $master_branch
  cd ..
done

echo "--DOTCOM--"
for i in shop zest; do
  cd $i
  echo $i
  git co dotcom
  git push --delete origin $dotcom_branch
  git branch -D $dotcom_branch
  cd ..;
done
