require 'fileutils'

class GitCache
  def self.refresh(git_url)
    new(git_url).refresh
  end

  def initialize(git_url)
    @git_url = git_url
  end

  def refresh
    if Dir.exist? git_url.cache_path
      fetch
    else
      clone
    end
  end

  private

  attr_reader :git_url

  def clone
    FileUtils.mkdir_p git_url.cache_path
    system "git clone --mirror #{git_url.url} #{git_url.cache_path}"
  end

  def fetch
    Dir.chdir git_url.cache_path
    system 'git fetch'
  end
end
