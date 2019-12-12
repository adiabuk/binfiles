#!/usr/bin/env bash

version=$1

for i in shop zest caramel brain magpie kit; do
  cd $i
  git fetch &>/dev/null;
  cd ..
done

echo "--MASTER--"
for i in shop zest caramel brain magpie kit; do
  cd $i;
  echo $i;
  git co release-master-$version &>/dev/null;
  git log | grep Failed.*$version
  git log | grep Automerged.*$version
  cd ..
done

echo "--DOTCOM--"
for i in shop zest; do
  cd $i
  echo $i
  git co release-dotcom-$version &>/dev/null;
  git log | grep Failed.*$version;
  git log | grep Automerged.*$version
  git co master &>/dev/null;
  cd ..;
done
