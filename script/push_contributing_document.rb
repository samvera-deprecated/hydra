require 'github_api'
require 'open-uri'
require File.expand_path('../../lib/hydra/version', __FILE__)

#
# You will need to use one of your properly scoped Github authentication keys:
# $ curl -u 'YOUR GITHUB USERNAME' -d '{"scopes":["repo"],"note":"Read/Write for your Repos"}' https://api.github.com/authorizations
#
# Then run this script:
# `ruby script/push_contributing_docuemnt.rb SUPER-SECRET-TOKEN`
#
AUTHORIZATION_TOKEN = ARGV.fetch(0)
MESSAGE = "Updating CONTRIBUTING.md as per Hydra v#{Hydra::VERSION}"

github = Github.new oauth_token: AUTHORIZATION_TOKEN
branch_name = "updating-contributing-guidelines-#{Time.now.strftime('%Y-%m-%d-%H-%M-%S')}"

def with_pull_request_creation(organization_name:, repo:, branch_name:)
  master_sha = github.git_data.references.get(organization_name, repo.name, 'heads/master').body.object.sha
  github.git_data.references.create(organization_name, repo.name, ref: "refs/heads/#{branch_name}", sha: master_sha)
  yield
  github.pull_requests.create(
    organization_name,
    repo.name,
    title: MESSAGE,
    body: "```console\nruby script/#{File.basename(__FILE__)} SUPER-SECRET-TOKEN\n```\n",
    head: branch_name,
    base: master
  )
end

['projecthydra', 'projecthydra-labs'].each do |organization_name|

  repos = github.repos.list(org: organization_name)
  contributing_content = File.read(File.expand_path('../../CONTRIBUTING.md', __FILE__))

  repos.each do |repo|
    begin
      output = github.repos.contents.get(organization_name, repo.name, 'CONTRIBUTING.md', path:'CONTRIBUTING.md')
      # Check if we already have this content
      if output.body.content == Base64.encode64(contributing_content)
        puts "Skipped #{repo.full_name} CONTRIBUTING.md"
        next
      end

      # And we'll go ahead and update the file
      with_pull_request_creation(organization_name: organization_name, repo: repo, branch_name: branch_name) do
        github.repos.contents.update(
          organization_name, repo.name, 'CONTRIBUTING.md',
          path:'CONTRIBUTING.md',
          content: contributing_content,
          sha: output.sha,
          branch: branch_name,
          message: MESSAGE
        )
        puts "Updated #{repo.full_name} CONTRIBUTING.md"
      end
    # Looks like its time to create the file
    rescue Github::Error::NotFound
      with_pull_request_creation(organization_name: organization_name, repo: repo, branch_name: branch_name) do
        github.repos.contents.create(
          organization_name, repo.name, 'CONTRIBUTING.md',
          path:'CONTRIBUTING.md',
          content: contributing_content,
          branch: branch_name,
          message: MESSAGE
          )
        puts "Created #{repo.full_name} CONTRIBUTING.md"
      end
    end
  end
end
