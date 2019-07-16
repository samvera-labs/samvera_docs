require 'tmpdir'

class Publisher
  attr_reader :tmp_dir

  def publish
    @tmp_dir = Dir.mktmpdir
    `git clone #{gh_pages_repo} #{@tmp_dir}`
    `bundle exec jekyll build -d #{@tmp_dir}`
    Dir.chdir @tmp_dir do
      `git add .`
      `git commit -m "Publishing with Publisher tool."`
      `git push`
    end
    # `rm -rf #{@tmp_dir}`
  end

  def self.publish
    new.publish
  end

  private

    def gh_pages_repo
      'git@github.com:afred/afred.github.io.git'
    end
end
