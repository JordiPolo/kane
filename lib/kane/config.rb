require 'yaml'
module Kane
  class Config

    def [](key)
      config[key]
    end

    def method_missing(name, *args, &block)
      config[name.to_s] || fail(NoMethodError, "unknown configuration key #{name}", caller)
    end


    private

    def config
      return @config unless @config.nil?
      fail IOError, "Configuration file #{location} not found " unless File.exist?(location)
      @config = YAML.load_file(location)
    end

    def location
      File.join(root, 'config', 'kane.yml')
    end

    def root
      if defined?(Rails)
        Rails.root
      else
        File.expand_path '../../..', __FILE__ #we have been called in the commandline
      end
    end
  end
end