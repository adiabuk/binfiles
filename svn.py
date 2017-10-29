from base import *

# All remediations must subclass Remediable
class master_lock_check(Remediable):
    # Remediation owners
    owners = ['amro']

    # Check for a problem
    @simple_check
    def check(self):
        command = '/usr/facebook/ops/scripts/cfengine/cfhook.sh --checkmasterfiles'
        result = self.host.run(command, timeout=240, with_exit_code=True)
        return result['exit_code'] == 0


    def get_directories(self,base_dir):
        dir_list=()
        dir_list = os.listdir(base_dir)
        return dir_list

    # Attempt to fix the problem
    @simple_remediate
    def remediate(self):
        if self.check():
          path_to_repo = ''
          result = self.host.run('/usr/local/bin/svn cleanup' + path_to_repo)
    common_dir = '/usr/local/masterfiles/workdir/'
    dir1 = common_dir + 'opsfiles.workingcopy/PROD/'
    dir2 = common_dir + 'opsfiles_bin.workingcopy/'
    final_dirs = []
    for search_dirs in dir1, dir2:
        final_dirs.append(get_directories(search_dirs))
    for final_dir in final_dirs:
      cleanup_result = self.host.run('/usr/local/bin/svn cleanup ' + final_dir,timeout=240, with_exit_code=True)
      check_result = self.host.run('/usr/local/bin/svn cleanup ' + final_dir,timeout=240, with_exit_code=True)

