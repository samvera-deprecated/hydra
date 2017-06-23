# 1. Get a personal access token from GitHub (https://github.com/settings/tokens)
#    with the following scopes enabled:
#    * public_repo
#    * read:org
#    * user:email
# 2. Set an ENV variable named 'GITHUB_SAMVERA_TOKEN' containing your token
# 3. Then run this script:
#    $ ruby ./script/grant_revoke_gem_authority.rb
#
# To also revoke ownership from users whose email addresses are not in the list:
# $ WITH_REVOKE=true ruby ./script/grant_revoke_gem_authority.rb
#
# To print more information on what the script is doing:
# $ VERBOSE=true ruby ./script/grant_revoke_gem_authority.rb

require 'github_api'
require 'open3'

AUTHORIZATION_TOKEN = ENV['GITHUB_SAMVERA_TOKEN'] || raise("GitHub authorization token was not found in the GITHUB_SAMVERA_TOKEN environment variable")
ORGANIZATION_NAMES = ['samvera', 'samvera-labs', 'samvera-deprecated']
# Some GitHub user instances do not have an email address defined,
# so start with the prior list of addresses (registered with Rubygems.org)
KNOWN_COMMITTER_EMAIL_ADDRESSES = {
  'awead' => "amsterdamos@gmail.com",
  'atz' => 'ohiocore@gmail.com',
  'barmintor' => "armintor@gmail.com",
  'bess' => "bess@curationexperts.com",
  'cam156' => "cam156@psu.edu",
  'cbeer' => "chris@cbeer.info",
  'cjcolvar' => "cjcolvar@indiana.edu",
  'coblej' => "jim.coble@duke.edu",
  'DanCoughlin' => "dan.coughlin@gmail.com",
  'darrenleeweber' => 'dweber.consulting@gmail.com',
  'dchandekstark' => "dchandekstark@gmail.com",
  'elrayle' => 'elrayle@hotmail.com',
  'escowles' => 'escowles@ticklefish.org',
  'grosscol' => 'grosscol@gmail.com',
  'hackmastera' => 'anna3lc@gmail.com',
  'hortongn' => 'glen.horton@gmail.com',
  'jeremyf' => "jeremy.n.friesen@gmail.com",
  'jenlindner' => 'jenlindner@gmail.com',
  'jkeck' => "jessie.keck@gmail.com",
  'jpstroop' => "jpstroop@gmail.com",
  'jcoyne' => "digger250@gmail.com",
  'lawhorkl' => 'lawhorkl@mail.uc.edu',
  'mjgiarlo' => "leftwing@alumni.rutgers.edu",
  'mark-dce' => "mark@curationexperts.com",
  'mbklein' => "mbklein@gmail.com",
  'mkorcy' => "mkorcy@gmail.com",
  'ndushay' => "ndushay@stanford.edu",
  'tpendragon' => "tpendragon@princeton.edu",
  'carrickr' => 'carrickr@umich.edu',
  'little9' => 'jamielittle@outlook.com',
  'no_reply' => 'johnson.tom@gmail.com',
  'revgum' => 'revgum@gmail.com'
}
# Some GitHub repositories are named differently from their gems
KNOWN_MISMATCHED_GEM_NAMES = {
  'active_fedora' => 'active-fedora',
  'fcrepo-admin' => 'fcrepo_admin',
  'questioning_authority' => 'qa'
}
# GitHub repositories with matching gems that aren't from Samvera
FALSE_POSITIVES = [
  'hypatia',
  'rdf-vocab',
  'lerna',
  'hydrangea'
]
# Gems that do not have their own GitHub repositories
HANGERS_ON = [
  'hydra-core',
  'hydra-access-controls',
  'sufia-models',
  'curation_concerns-models'
]
# Email addresses that are known not to be registered at rubygems.organization
SKIP_EMAILS = [
  'ggeisler@gmail.com',
  'dlrueda@stanford.edu',
  'jgreben@stanford.edu',
  'lmcglohon@gmail.com',
  'ssklar@stanford.edu',
  'tony.zanella@gmail.com',
  'blalbritton@gmail.com'
]
VERBOSE = ENV.fetch('VERBOSE', false)

puts "(Hang in there! This script takes a couple minutes to run.)"

github = Github.new(oauth_token: AUTHORIZATION_TOKEN, auto_pagination: true)

# Get the ID of the GitHub-provided "Owners" team from the samvera org
# We don't currently grant gem ownership to the folks in the other two orgs
# (This just preserves the prior behavior.)
owner_team_id = github.orgs.teams.list(org: 'samvera').select { |team| team.name == 'Admins' }.first.id
owners = github.orgs.teams.list_members(owner_team_id)
# Start with the prior (known to work) list of email addresses
committer_map = KNOWN_COMMITTER_EMAIL_ADDRESSES.dup
owners.each do |owner|
  user = github.users.get(user: owner.login)
  # Move along if the user doesn't have an email addy or if there's already an entry in the map
  next if !user.respond_to?(:email) || user.email.nil? || user.email.empty? || !committer_map[user.login].nil?
  committer_map[user.login] = user.email
end
committer_emails = committer_map.values.sort.uniq

# Keep track of things
@errors = []
@bogus_gem_names = []
@gem_names = HANGERS_ON

def exists?(name)
  system("gem owner #{name} > /dev/null 2>&1")
end

def replace_known_mismatch(name)
  KNOWN_MISMATCHED_GEM_NAMES.fetch(name, name)
end

ORGANIZATION_NAMES.each do |org_name|
  github.repos.list(org: org_name).each do |repo|
    name = replace_known_mismatch(repo.name)
    if exists?(name)
      @gem_names << name
    else
      @bogus_gem_names << repo.full_name
    end
  end
end

def gem_owner_with_error_check(gemname, params)
  command = "gem owner #{gemname} #{params}"
  puts "running: #{command}" if VERBOSE
  Open3.popen3(command) do |stdin, stdout, stderr, wait_thr|
    @errors << "#{gemname} #{params}: #{stdout.read.chomp}" unless wait_thr.value.success?
  end
end

@gem_names.reject { |gemname| FALSE_POSITIVES.include?(gemname) }.sort.each do |gemname|
  current_committers = `gem owner #{gemname} | grep -e ^-`.split("\n")
  current_committers.collect! { |cc| cc.sub(/^.\s+/,'')}

  if ENV.fetch('WITH_REVOKE', false)
    committers_to_remove = current_committers - committer_emails
    remove_params = committers_to_remove.map { |email| "-r #{email}" }.join(' ')
    gem_owner_with_error_check(gemname, remove_params)
  end

  committers_to_add = committer_emails - current_committers - SKIP_EMAILS
  add_params = committers_to_add.map { |email| "-a #{email}" }.join(' ')
  gem_owner_with_error_check(gemname, add_params)
end

if @bogus_gem_names.any?
  $stderr.puts("WARNING: These Samvera repositories do not have gems:\n - #{@bogus_gem_names.sort.join("\n - ")}")
  $stderr.puts("\n")
end

if @errors.any?
  $stderr.puts("The following errors were encountered:")
  $stderr.puts(%(#{@errors.sort.join("\n")}))
end
