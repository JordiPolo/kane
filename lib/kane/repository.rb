require 'octokit'
require 'base64'
require 'fileutils'
require 'tmpdir'
require 'bundler'
require 'bundler/cli'
require 'bundler/cli/outdated'
require 'semverly'


module Kane

  class Repository
    attr_reader :project

    def initialize(gitrepo, config)
      @project = gitrepo
      @config = config
    end

    def uses_rails?
      @uses_rails ||= begin
        return false if project.language == 'C#'
        return false unless project.language
        uses_gem?('rails') && !repo_file('config.ru').empty?
      end
    end

    def gems
      return [] unless uses_rails?
      with_downloaded_gemfiles do
        specs = Bundler.locked_gems.specs.select do |spec|
          spec.source.to_s.include?(@config.organization) || @config.gems.include?(spec.name)
        end
        specs.map do |spec|
          {
            name: spec.name,
            version: spec.version,
         #   source: spec.source.to_s,
            max_version: latest_version(spec)
          }
        end
      end
    end
    private
   # @@latest_gems = {}
    @@latest_tags = {}


    def latest_version(spec)
      if spec.source.to_s.include?(@config.organization)
        latest_tag(spec)
      else
        latest_rubygem(spec)
      end
    end

    def latest_rubygem(spec)
      RubyGems.new.max_usable_version_for(spec)
    end

    def latest_tag(spec)
      return @@latest_tags[spec.name] if @@latest_tags[spec.name]
      puts "doing #{spec.name}"
      max = TaggedGems.new.max_usable_version_for(spec)
      @@latest_tags[spec.name] = max
      max
    end

    def uses_gem?(gem_name)
      gemfile_lock = repo_file('Gemfile.lock')
      gemfile_lock.include?(gem_name)
    end


    def repo_file(filename)
      content = project.rels[:contents].get(uri: { path: filename}).data[:content]
      Base64.decode64(content)
    rescue Octokit::NotFound => exception
      ''
    end

    def with_downloaded_gemfiles
      gemfile = repo_file('Gemfile')
      gemfilelock = repo_file('Gemfile.lock')
      dir = Dir.mktmpdir
      File.open(File.join(dir, 'Gemfile'), 'wb+') {|f| f.write(gemfile) }
      File.open(File.join(dir, 'Gemfile.lock'), 'wb+') {|f| f.write(gemfilelock) }
      ENV['BUNDLE_GEMFILE'] = File.join(dir, 'Gemfile')
      result = yield
      Bundler.remove_instance_variable '@locked_gems'
      FileUtils.rm_r dir
      result
    end

  end

end

