
module Kane
  class RubyGems

    def max_usable_version_for(spec)
      current_version = SemVer.parse(spec.version.to_s)
      return spec.version.to_s unless current_version

      all_versions = all_versions_for(spec.name)
      greater = TagList.new(all_versions).all_greater_than(spec.version.to_s)

      allowed_greater = greater.select do |version|
        greater_version = SemVer.parse(version)
        next unless greater_version
        if spec.name == 'rails'
          greater_version.major == current_version.major &&
          greater_version.minor == current_version.minor
        else
          greater_version.major == current_version.major
        end
      end
      allowed_greater.max || spec.version.to_s
    end

    private
    def all_versions_for(gemname)
      conn = Faraday.new('https://rubygems.org/')
      body = conn.get("/api/v1/versions/#{gemname}.json").body
      all_versions = JSON.parse(body).map do |version|
        version['number'] unless version['prerelease']
      end.compact
    end
  end
end