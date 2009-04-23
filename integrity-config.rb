require "rubygems"
require "tempfile"
gem "integrity"
require "integrity"

Integrity.config = {
  :base_uri         => 'http://YOUR_APP_NAME.heroku.com',
  :database_uri     => ENV["DATABASE_URL"],
  :export_directory => File.dirname(__FILE__) + "/tmp",
  :log              => File.dirname(__FILE__) + "/log/integrity.log",
  :use_basic_auth   => true,
  :admin_username   => "username",
  :admin_password   => "password",
  :hash_admin_password => false
}

module Integrity
  class Project
    module Helpers
      module Push
        def unfuddle_push(payload)
          build
        end
        
        alias_method :github_push, :push
        alias_method :push, :unfuddle_push
      end
    end
  end
  
  module SCM
    class Git
      private
      def clone_with_prepared_env
        log "Making private git repos accessible"
        FileUtils.cp(File.join(File.dirname(__FILE__), "ssh_pkey"), "/tmp/your_ssh_pkey")
        FileUtils.cp(File.join(File.dirname(__FILE__), "git_ssh"),  "/tmp/your_git_ssh")
        File.chmod(0600, '/tmp/your_ssh_pkey')
        File.chmod(0711, '/tmp/your_git_ssh')
        
        clone_without_prepared_env
      end

      alias_method :clone_without_prepared_env, :clone
      alias_method :clone, :clone_with_prepared_env 
    end
  end
end

Integrity.new
