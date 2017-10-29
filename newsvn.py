#!/usr/bin/python -tt

import os
import sys
import re
import proc

def get_directories(base_dir):
  dir_list=()
  try:
    dir_list = os.listdir(base_dir)
  except OSError, e:
    print "Error caught: %s" %e
  print dir_list
  for index, item in enumerate(dir_list):
    dir_list[index] = base_dir + item
  return dir_list

def find_bad_repositories(list_of_repos):
  bad_repos = []
  for repo in list_of_repos:
    #print "looking at %s" % repo
    out, err,exit_code = proc.run(['/usr/bin/svn', 'status', '%s' % repo],timeout=10)
    match = re.search(r"\s\sL\s+\S+",out)   # Match L as 3rd character followed by some whitespace then dir name (non-whitespace)
    #print err,out
    if match:
      bad_repos.append(repo)
      print "%s is broken" % repo
    else:
      print "%s is OK" %repo
  return bad_repos
 
def fix(current_repository):
  out,err, exit_code = proc.run(['/usr/bin/svn', 'cleanup', '%s' %current_repository],timeout=10)
  print err,out
  if exit_code == 0:
    return True
  else:
    return False

def remediate():
   
  common_dir = '/usr/local/masterfiles/workdir/'
    #dir1 = common_dir + 'opsfiles.workingcopy/PROD/'
    #dir2 = common_dir + 'opsfiles_bin.workingcopy/'
  repositories = ('/home/amro/myrepos/repo3', '/home/amro/myrepos/repo2', '/home/amro/myrepos/repo4')
  fixed_all_repos = []
  print "checking repos, pass 1"
  repos_to_fix = find_bad_repositories(repositories)  
 
  if not repos_to_fix:
    print "false alarm - clearing alarm"
    sys.exit(0)

  for repo in repos_to_fix:
    print "fixing %s" % repo
    fix(repo)
    
  print "Rechecking..."
  repos_still_to_fix = find_bad_repositories(repositories)
  if repos_still_to_fix:
    print "unable to fix repo, escalating"  
  else:
    print "clearing alarm"
           

if __name__ == '__main__':
  remediate()
