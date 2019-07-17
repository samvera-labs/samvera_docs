require 'tmpdir'
require 'logger'
require 'yaml'

class Publisher
  attr_reader :tmp_dir

  def publish
    validate_in_sync_with_master!
    validate_required_config!
    logger.info "Site is ready! Publishing to #{gh_pages_repo} (branch='#{gh_pages_branch}')..."
    Dir.mktmpdir do |tmp_dir|
      print_and_run "git clone #{gh_pages_repo} #{tmp_dir}"
      print_and_run "bundle exec jekyll build -d #{tmp_dir}"
      Dir.chdir tmp_dir do
        print_and_run "git add ."
        print_and_run "git commit -m \"#{git_commit_msg}\""
        print_and_run "git push"
      end
    end
  end

  # Convenience class method
  def self.publish;  new.publish; end

  private

    def validate_in_sync_with_master!
      ahead, behind = `git rev-list --left-right --count origin/master...HEAD`.split(/\s/).map(&:to_i)
      raise_not_in_sync_with_master(ahead, behind) unless ahead == 0 && behind == 0
    end

    def validate_required_config!
      required_config_keys.each do |key, desc|
        raise_missing_config_option(key, desc) unless config[key]
      end
    end

    def required_config_keys
      {
        'gh_pages_repo' => "The Github Pages repository URL",
        'gh_pages_branch' => "The branch Github Page has been configured to " \
                             "read from (default: 'master')."
      }
    end

    # shortcuts to config
    def gh_pages_repo; config['gh_pages_repo']; end
    def gh_pages_branch; config['gh_pages_branch']; end

    def print_and_run(command)
      logger.info "Running: #{command}"
      `#{command}`
    end

    def logger
      @logger ||= Logger.new(STDOUT)
    end

    def ready_to_publish?
      up_to_date? && required_config_present?
    end

    def up_to_date?
      false
    end

    def required_config_present?

    end

    def config
      @config ||= default_config.merge(config_from_yaml)
    end

    def default_config
      {'gh_pages_branch' => 'master'}
    end

    def config_from_yaml
      YAML.load_file(config_file_path).fetch('publish', {})
    end

    def config_file_path
      File.expand_path('../../_config.yml', __FILE__)
    end

    def raise_missing_config_option(key, example=nil)
      msg = "Missing required configuration option: '#{key}'." \
            "\n\n# add this to #{config_file_path}:" \
            "\npublish:" \
            "\n  #{key}: # #{example || "your value here"}\n\n"
      raise msg
    end

    def raise_not_in_sync_with_master(ahead, behind)
      msg = "\nThis branch is not in sync with remote master." \
            "\nYou are #{ahead} commits ahead and #{behind} commits " \
            "behind #{gh_pages_repo}/#{gh_pages_branch}" \
            "\nYou can only publish when your local branch is the same as " \
            "#{gh_pages_repo}/#{gh_pages_branch}\n\n"
      raise msg
    end
end
