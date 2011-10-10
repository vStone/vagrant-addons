module Vagrant
  module Command
    class PuppetMasterCommand < Vagrant::Command::GroupBase
      register "puppetmaster", "Control a contained puppetmaster instance"

      source_root File.expand_path("../templates", __FILE__)

      desc "todo", "A todo list of that needs to be done to get this working"
      def todo()
        env.ui.info("@todo:")
        env.ui.info("1. Check if making this method a subcommand works")
        env.ui.info("2. Add method to generate a config (thats working)")
        env.ui.info("3. Read the stored configuration and use that to generate the config")
        env.ui.info("4. Add method to start puppetmaster")
        env.ui.info("5. Adjust configuration to autosign stuff etc etc. Make it useable!")
        env.ui.info("6. Add method to stop puppetmaster")
        env.ui.info("7. Add method to reset puppetmaster data (gets rid of everything but the configuration)")
      end
    end
    
    
    class PuppetCommand < Vagrant::Command::GroupBase
      register "puppet", "Do all sorts of fun stuff with puppet"

      source_root File.expand_path("../templates", __FILE__)

      desc "master", "Control a contained puppetmaster instance"
      subcommand "master", PuppetMasterCommand

      desc "mkdirs", "Create a default puppet structure"
      def mkdirs() 
        env.ui.info "Creating basic structure"
        empty_directory "manifests"
        empty_directory "modules"
        opts = {}
        template('puppet_init.tt', "manifests/init.pp", opts)
      end

      desc "module_create [NAME]", "Create a new puppet module structure"
      def module_create(name)
        env.ui.info "Create puppet module structure for new module '#{name}'"
        empty_directory "modules/#{name}/templates"
        empty_directory "modules/#{name}/manifests"
        opts = { :name => "#{name}" }
        template('module_init.tt', "modules/#{name}/manifests/init.pp", opts)
      end

      desc 'module_add [NAME]', 'Add an existing puppet module to your modules'
      method_option :force, :aliases => '-f', :desc => "Force adding this module: overwrites existing module with same name"
      def module_add(name)
        env.ui.info "Adding module #{name}."
      end


    end
  end
end
