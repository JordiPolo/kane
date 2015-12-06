require 'kane/config'
require 'faraday'


module Kane
  class TaggedGems
    def max_usable_version_for(spec)
      config = Kane::Config.new
      client = Octokit::Client.new(login: config.login, password: config.password, auto_traversal: true, auto_paginate: true)
      github_repo_str = /.*?(\w+\/#{spec.source.name})\.git/.match(spec.source.uri)
      return '0' unless github_repo_str
      github_repo = github_repo_str.captures.first
      tags = client.tags(github_repo).map{|tag| clean_tag(tag[:name])}
      max = TagList.new(tags).all_greater_than(spec.version.to_s).max || spec.version.to_s
    end

    private
    def clean_tag(tag_string)
      parsed_tag_str = tag_string
      parsed_tag_str = parsed_tag_str[1..-1] if parsed_tag_str.start_with?('v')
      parsed_tag_str
    end
  end

end