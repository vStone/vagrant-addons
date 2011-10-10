module Vagrant
  module Command
    class PuppetCommand < Vagrant::Command::GroupBase
      register "puppet", "Do all sorts of fun stuff with puppet"

      source_root File.expand_path("../templates", __FILE__)

      desc "module_create NAME", "Create a new puppet module structure."
      def module_create(name)
        env.ui.info "Create puppet module structure for new module '#{name}'"
        empty_directory "modules/#{name}/templates"
        empty_directory "modules/#{name}/manifests"
        opts = { :name => "#{name}" }
        template('module_init.tt', "modules/#{name}/manifests/init.pp", opts)
      end

      desc 'module_add NAME', 'Add an existing puppet module to your modules'
      method_option :force, :aliases => '-f', :desc => "Force adding this module: overwrites existing module with same name"
      def module_add(name)
        env.ui.info "Adding module #{name}."
      end
    end
  end
end
