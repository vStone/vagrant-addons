module Vagrant
  module Command
    class PuppetMasterCommand < Vagrant::Command::GroupBase
      register "puppetmaster", "Control a contained puppetmaster instance"

      source_root File.expand_path("../templates", __FILE__)

      desc "todo", "A todo list of that needs to be done to get this working"
      def todo()
        env.ui.info("@todo:")
        env.ui.info("1. Add method to generate a config (thats working):: In progress")
        env.ui.info("2. Read the stored configuration and use that to generate the config")
        env.ui.info("3. Add method to start puppetmaster")
        env.ui.info("4. Adjust configuration to autosign stuff etc etc. Make it useable!")
        env.ui.info("5. Add method to stop puppetmaster")
        env.ui.info("6. Add method to reset puppetmaster data (gets rid of everything but the configuration)")
      end

      desc "genconfig", "Generate a puppetmaster configuration setup"
      method_option :name, :aliases => '-n', :type => :string, :default => "puppetmaster", 
        :desc => 'A custom name for the puppetmaster. This is also used as target folder where the configuration will be setup.'
      method_option :manifestdir, :aliases => '-m', :type => :string,
        :desc => 'Where puppet master looks for his manifests. Defaults to ./manifests .'
      method_option :modulepath, :aliases => '-p', :type => :string,
        :desc => 'The search path for modules as a colon seperated list of directories. Defaults to ./modules .'
      method_option :bindaddress, :aliases => '-b', :type => :string, :default => '',
        :desc => 'Which address puppet master binds on.'
      method_option :masterport, :aliases => '-p', :type => :numeric, :default => 8140,
        :desc => 'Which port puppet master listens on.'
      method_option :puppetport, :aliases => '-c', :type => :numeric, :default => 8139,
        :desc => 'Which port pupet agent listens on.'
      method_option :user, :aliases => '-u', :type => :string,
        :desc => 'User name to run puppetmaster as. Defaults to current user.'
      method_option :group, :aliases => '-g', :type => :string,
        :desc => 'Group name to run puppet master as. Defaults to current group.'
      def genconfig()
        begin
          require 'etc'
        rescue LoadError
          env.ui.error "Using genconfig requires the gem 'etc' installed."
          exit
        end

        ## todo: use env for user/group stuff and maybe hostname?
        ## todo: use some of the customization options (method_option) for defaulting these values below
        name = options[:name]
        env.ui.info "Generate the config: '#{name}"
        env.ui.info "Target: ./#{name}/"

        username = options[:user]
        if ! username
          username = Etc.getpwuid(Process.euid).name
        end

        groupname = options[:group]
        if ! groupname
          groupname = Etc.getgrgid(Process.egid).name
        end

        manifest_dir = options[:manifestdir]
        if ! manifest_dir
          manifest_dir = File.expand_path(File.join(".", "manifests"))
        end

        if File.exists(File.join(manifest_dir), 'site.pp')
          initfile = File.join(manifest_dir), 'site.pp')
        else
          initfile = File.join(manifest_dir), 'init.pp')
        end

        module_path = options[:modulepath]
        if ! module_path
          module_path = File.expand_path(File.join(".", "modules"))
        end

        ## Default is set by method_option
        master_port = options[:masterport]
        puppet_port = options[:puppetport]


        opts = { 
          :name => name,
          :rundir => "./#{name}/run",
          :vardir => "./#{name}/var",
          :confdir => "./#{name}/",
          :config => "./#{name}/puppetmaster.conf",
          :logdir => "./#{name}/logs",
          :manifestdir => manifest_dir,
          :modulepath => module_path,
          :bindaddress => '',
          :masterport => 8140,
          :puppetport => 8139,
          :puppet_user => username,
          :puppet_group => groupname,
          :initfile   => initfile,
        }
        directory('puppetmaster', "./#{name}/", opts)

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
      method_option :force, :aliases => '-f', :type => :boolean, :desc => "Force adding this module: overwrites existing module with same name"
      def module_add(name)
        env.ui.info "Adding module #{name}."
      end


    end
  end
end
