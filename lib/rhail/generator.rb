require 'fileutils'

module Rhail
  class Generator # :nodoc:
    attr_reader :folder, :type

    def initialize(type: 'plain', folder: './', rvm_ruby: '2.3.3', rvm_gemset: nil)
      @type       = type
      folder      = (folder == nil || folder.size == 0) ? './' : folder
      @folder     = File.expand_path(folder)
      @rvm_ruby   = rvm_ruby
      @rvm_gemset = rvm_gemset || "ruby-hail-generated-#{@type}"
    end

    def create_folder_with_app
      unless Dir.exists? @folder
        FileUtils.mkdir_p @folder
      end

      FileUtils.cp_r File.expand_path("../../../generator_folders/#{@type}", __FILE__), @folder

      if @rvm_ruby
        File.open("#{@folder}/#{@type}/.ruby-version", 'w+') do |f|
          f.write "#{@rvm_ruby}@#{@rvm_gemset}\n"
        end
      end
    end

    def install_dependencies
      rvm_cmd = `which rvm`.chomp
      rvm_full_cmd = ''
      if rvm_cmd.length > 0
        rvm_full_cmd = "#{rvm_cmd} #{@rvm_ruby}@#{@rvm_gemset} do"
      end

      install_bundler_cmd = "cd #{@folder}/#{@type} && #{rvm_full_cmd} gem install bundler"
      puts install_bundler_cmd
      system(install_bundler_cmd)

      bundle_install_cmd = "cd #{@folder}/#{@type} && #{rvm_full_cmd} bundle install"
      puts bundle_install_cmd
      system(bundle_install_cmd)
    end

  end
end
