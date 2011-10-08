## @todo: Include an update command that adds new boxes that are not defined yet and suggest cleanup for unexisting boxes.


module Vagrant
  module Command
    class ConfigCommand < Vagrant::Command::GroupBase
      register "config", "Some Vagrantfile configuration tools"

      source_root File.expand_path(FileUtils.pwd() + "/.templates", Vagrant.source_root)

      
      desc "multivm_gen", "Generate multivm statements for all installed boxes"
      def multivm_gen
        boxes = env.boxes.sort 
        opts = {
          :boxes => boxes,
        }
        template('multivm_gen.tt', 'MultiVMVagrantfile', opts)
        env.ui.info("Don't forget to add the following statements in your Vagrantfile")
        env.ui.info("Add them in between the Vagrant::Config.run block.")
        env.ui.info("
  #--- Snippet ---
  ## Automagicly generate a multivm env for every box vagrant has available
  if File.exist?('MultiVMVagrantfile')
    $config = config
    load 'MultiVMVagrantfile'
  end

  #--- Snippet ---
", { :prefix => false })
      end
    end
  end
end


