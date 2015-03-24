require 'docker'
require 'json'
require 'colorize'
require 'builder'

class Application
  def initialize(data, dir, sha)
    self.sha = sha
    self.name = data['application']['name']
    self.path = dir
    self.builder = Builder.load_builder(application: self, build: data['build'])
    self.repo = data['application']['repo'] || local_repo
  end

  attr_reader :builder, :path, :name, :repo

  def build
    self.image = builder.build
  end

  def push
    if @local_repo
      $stderr.puts 'no repo specified in config only building project localy'
    else
      push_image
    end
  end

  def full_tag
    "#{repo}:#{tag}"
  end

  def tag
    @_tag ||= "#{sha}_#{timestamp}"
  end

  protected

  attr_writer :builder, :path, :name, :repo
  attr_accessor :sha, :image

  private

  def push_image
    auth_docker
    puts "pushing #{full_tag} =>".bold.green
    image.push { |chunk| format_push_status(chunk) }
  end

  def auth_docker
    dockercfg.each do |index, config|
      Docker.authenticate!(
        'email' => config['email'],
        'username' => username(config['auth']),
        'password' => password(config['auth']),
        'serveraddress' => index,
      )
    end
  end

  def format_push_status(chunk)
    json = JSON.parse(chunk)

    if json['error']
      $stderr.puts json['error']
      exit 1
    end

    case json['status']
    when 'Pushing'
      print '.'
    when 'Buffering to disk'
      print '.'
    when 'Image successfully pushed'
      puts "\n#{json['status']}"
    else
      puts json['status']
    end
  end

  def username(auth)
    decode(auth).first
  end

  def password(auth)
    decode(auth).last
  end

  def decode(auth)
    Base64.decode64(auth).split(':')
  end

  def dockercfg
    JSON.parse(ENV['DOCKERCFG'])
  end

  def timestamp
    Time.now.strftime('%Y%m%d%H%M%S')
  end

  def local_repo
    @local_repo ||= name.downcase.gsub(/[^a-z0-9\-_.]/,'')
  end
end
