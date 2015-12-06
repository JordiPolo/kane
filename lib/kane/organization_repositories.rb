require 'kane/config'
require 'kane/repository'
require 'octokit'

module Kane
  class OrganizationRepositories

    def self.all(limit=nil)
      config = Kane::Config.new
      client = Octokit::Client.new(login: config.login, password: config.password, auto_traversal: true, auto_paginate: true)

      repo_response = client.organization(config.organization).rels[:repos].get

      repositories = repo_response.data

      return repositories.first(limit).map{|gitrepo| Kane::Repository.new(gitrepo, config)} if limit

      while(repo_response.rels[:next])
        repo_response = repo_response.rels[:next].get
        repositories.concat(repo_response.data)
      end
      repositories.map{|gitrepo| Kane::Repository.new(gitrepo, config)}
    end
  end
end