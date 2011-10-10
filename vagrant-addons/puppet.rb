module Vagrant
  module Command
    class PuppetCommand < Vagrant::Command::GroupBase
      register "puppet", "Do all sorts of fun stuff with puppet"

      source_root File.expand_path("../templates", __FILE__)

      desc "module_add NAME", "Do stuff with modules"
      def module_add(name)
        env.ui.info "Create puppet module structure for new module '#{name}'"
        empty_directory "modules/#{name}/templates"
        empty_directory "modules/#{name}/manifests"
        opts = { :name => "#{name}" }
        template('module_init.tt', "modules/#{name}/manifests/init.pp", opts)
      end
    end
  end
end
