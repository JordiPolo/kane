# Kane

Kane finds all the gems used by your projects in a given organization.
It can be used to check if your projects are up to date.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kane'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kane

## Usage

### Standalone
If you just want to have a report (all data will be stored in data.json)
- Clone the repo
- Edit config/kane.yml and add your credentials and the organization.
- run bin/kane

If you have many repositories in your organization, then it will take a
while.


### Inside a Rails project

Add the gem to your gemfile, add a config/kane.yml.
You can use the information created by kane by for instance making a
rake task like this:
```ruby
task :update_projects do
  repos = Kane::OrganizationRepositories.all

  repo_data = repos.map do |repo|
    puts "Getting #{repo.project.name}"
    project = Project.where(name: repo.project.name).first
    if project
      if project.rails
        project.gems = repo.gems
        project.save
      end
    else
      puts "new project: #{repo.project.name}, #{repo.uses_rails?}"
      project.name = repo.project.name
      project.language = repo.project.language
      project.rails = repo.uses_rails?
      project.gems = repo.gems
      project.save
    end
  end
end
```


## Development

run tests by executing
```bash
bundle exec rspec
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jordipolo/kane.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

