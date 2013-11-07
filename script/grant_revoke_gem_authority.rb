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
  'hydra-file_characterization',
  'jettywrapper',
  'om',
  'qa',
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
  "jim.coble@duke.edu",
  "justin@curationexperts.com",
  "leftwing@alumni.rutgers.edu",
  "matt@curationexperts.com",
  "mbklein@gmail.com",
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

  if ENV.fetch('WITH_REVOKE', false)
    committers_to_remove = current_committers - HYDRA_COMMITTER_EMAILS
    remove_params = committers_to_remove.map {|email| "-r #{email}"}.join(' ')
    system_command_with_error_check("gem owner #{gemname} #{remove_params}")
  end

  committers_to_add = HYDRA_COMMITTER_EMAILS - current_committers
  add_params = committers_to_add.map {|email| "-a #{email}"}.join(' ')
  system_command_with_error_check("gem owner #{gemname} #{add_params}")
end

if ! @errors.empty?
  $stderr.puts("The following errors were encountered:")
  $stderr.puts(%(#{@errors.join("\n")}))
end
