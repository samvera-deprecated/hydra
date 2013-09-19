# To run:
# $ ruby ./script/grant_revoke_gem_authority.rb
RUBYGEM_NAMES = [
  'active-fedora',
  'active_fedora-registered_attributes',
  'active_fedora_relsint',
  'fcrepo_admin',
  'hydra',
  'hydra-access-controls',
  'hydra-batch-edit',
  'hydra-core',
  'hydra-derivatives',
  'hydra-editor',
  'hydra-head',
  'hydra-ldap',
  'hydra-migrate',
  'hydra-mods',
  'hydra-role-management',
  'jettywrapper',
  'om',
  'rubydora',
  'solrizer',
  'solrizer-fedora',
  'sufia',
  'sufia-models',
]

HYDRA_COMMITTER_EMAILS = [
  "amsterdamos@gmail.com",
  "armintor@gmail.com",
  "bess@stanford.edu",
  "cam156@psu.edu",
  "chris@cbeer.info",
  "cjcolvar@indiana.edu",
  "dan.coughlin@gmail.com",
  "dchandekstark@gmail.com",
  "edwin.shin@yourmediashelf.com",
  "jeremy.n.friesen@gmail.com",
  "jessie.keck@gmail.com",
  "john.scofield@yourmediashelf.com",
  "justin@curationexperts.com",
  "leftwing@alumni.rutgers.edu",
  "matt@curationexperts.com",
  "mbklein@gmail.com",
  "montyhindman@gmail.com",
  "mstrom81@gmail.com",
  "ndushay@stanford.edu",
]

@errors = []

def system_command_with_error_check(command)
  if !system(command)
    @errors << "ERROR FOR: #{command}"
  end
end
RUBYGEM_NAMES.each do |gemname|
  current_committers = `gem owner #{gemname} | grep -e ^-`.split("\n")
  current_committers.collect! { |cc| cc.sub(/^.\s+/,'')}
  committers_to_remove = current_committers - HYDRA_COMMITTER_EMAILS
  committers_to_add = HYDRA_COMMITTER_EMAILS - current_committers

  committers_to_remove.each do |email_to_remove|
    system_command_with_error_check("gem owner #{gemname} -r #{email_to_remove}")
  end

  committers_to_add.each do |email_to_add|
    system_command_with_error_check("gem owner #{gemname} -a #{email_to_add}")
  end
end

if ! @errors.empty?
  $stderr.puts("The following errors were encountered:")
  $stderr.puts(%(#{@errors.join("\n")}))
end
