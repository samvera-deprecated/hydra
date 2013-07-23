require 'github_api'
require File.expand_path('../../lib/hydra/version', __FILE__)

ORGANIZATION_NAME = 'projecthydra'

#
# You will need to use one of your properly scoped Github authentication keys:
# $ curl -u 'YOUR GITHUB USERNAME' -d '{"scopes":["repo"],"note":"Read/Write for your Repos"}' https://api.github.com/authorizations
#
# Then run this script:
# `ruby script/push_contributing_docuemnt.rb SUPER-SECRET-TOKEN`
#
AUTHORIZATION_TOKEN = ARGV.fetch(0)

github = Github.new oauth_token: AUTHORIZATION_TOKEN

repos = github.repos.list(org: ORGANIZATION_NAME)
contributing_content = File.read(File.expand_path('../../CONTRIBUTING.md', __FILE__))

repos.each do |repo|
  puts "Processing #{repo.full_name}"
  begin
    output = github.repos.contents.get(
      ORGANIZATION_NAME, repo.name, 'CONTRIBUTING.md',
      path:'CONTRIBUTING.md'
    )
    github.repos.contents.update(
      ORGANIZATION_NAME, repo.name, 'CONTRIBUTING.md',
      path:'CONTRIBUTING.md',
      content: contributing_content,
      sha: output.sha,
      message: "Updating CONTRIBUTING.md as per Hydra v#{Hydra::VERSION}\n\n[ci skip]"
    )
    puts "Updated #{repo.full_name} CONTRIBUTING.md"
  rescue Github::Error::NotFound
    github.repos.contents.create(
      ORGANIZATION_NAME, repo.name, 'CONTRIBUTING.md',
      path:'CONTRIBUTING.md',
      content: contributing_content,
      message: "Updating CONTRIBUTING.md as per Hydra v#{Hydra::VERSION}\n\n[ci skip]"

    )
    puts "Created #{repo.full_name} CONTRIBUTING.md"
  end
  puts "Processed #{repo.full_name}"
end
