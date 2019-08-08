require 'tmpdir'
require 'yaml'

# TODO: Consider turning this into a gem that implements a Jekyll::Command.
# Currently, you can't
class Publisher
  attr_reader :tmp_dir, :config

  def initialize(opts={})
    opts = opts.slice(:git_remote, :git_branch).compact
    @config = default_config.merge(config_from_yaml).merge(opts)
  end

  def publish
    validate_in_sync_with_origin_master!
    validate_no_unstaged_changes!
    validate_required_config!
    puts "Site is ready! Publishing to #{git_remote} (branch='#{git_branch}')..."
    Dir.mktmpdir do |tmp_dir|
      print_and_run "git clone #{git_remote} --branch #{git_branch} --single-branch #{tmp_dir}"
      print_and_run "bundle exec jekyll build -d #{tmp_dir}"
      Dir.chdir tmp_dir do
        puts "(within #{tmp_dir})"
        print_and_run "git add ."
        print_and_run "git commit -m \"#{git_commit_msg}\""
        print_and_run "git push #{git_remote} #{git_branch}"
      end
    end
  end

  # Convenience class method
  def self.publish;  new.publish; end

  private

    def validate_in_sync_with_origin_master!
      behind, ahead = `git rev-list --left-right --count origin/master...HEAD`.split(/\s/).map(&:to_i)
      raise_not_in_sync_with_origin_master(ahead, behind) unless ahead == 0 && behind == 0
    end

    def validate_no_unstaged_changes!
      count = `git diff --name-only`.split("\n").count
      raise_unstaged_changes(count) if count > 0
    end

    def validate_required_config!
      required_config_keys.each do |key, desc|
        raise_missing_config_option(key, desc) unless config[key]
      end
    end

    def required_config_keys
      {
        'git_remote' => "The Git repository url to push to.",
        'git_branch' => "The Git branch to push to (default: 'master')."
      }
    end

    # shortcuts to config
    def git_remote; config['git_remote']; end
    def git_branch; config['git_branch']; end

    def print_and_run(command)
      puts "Running: #{command}"
      `#{command}`
    end

    def default_config
      {'git_branch' => 'master'}
    end

    def config_from_yaml
      YAML.load_file(config_file_path).fetch('publish', {})
    end

    def config_file_path
      File.expand_path('../../_config.yml', __FILE__)
    end

    def git_commit_msg
      "Published: #{Time.now} " \
      "\nAuthor: #{git_user}" \
      "\nSummary: #{git_diff_shortstat}"
    end

    ###
    # Git shortcuts.
    ###
    def git_user; `git config user.name`; end
    def git_diff_shortstat; `git diff --shortstat HEAD~1..HEAD`; end

    ###
    # Error handling methods.
    ###
    def raise_missing_config_option(key, example=nil)
      msg = "Missing required configuration option: '#{key}'." \
            "\n\n# add this to #{config_file_path}:" \
            "\npublish:" \
            "\n  #{key}: # #{example || "your value here"}\n\n"
      raise msg
    end

    def raise_not_in_sync_with_origin_master(ahead, behind)
      msg = "This branch is not in sync with the upstream branch.\n" \
            "You are #{ahead} commit(s) ahead and #{behind} commit(s) " \
            "behind origin/master.\n" \
            "You can only publish when your local branch is in sync with " \
            "origin/master.\n\n"
      raise msg
    end

    def raise_unstaged_changes(count)
      msg = "You have #{count.to_i} unstaged changes that may affect how the " \
            "site is built.\n" \
            "You can only publish when your local branch is in sync with " \
            "origin/master.\n\n"
      raise msg
    end
end
