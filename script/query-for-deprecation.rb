#!/usr/bin/env ruby -wKU

# Given that the Hydra gem is pegged against specific versions other gems
# When we update the Hydra gem and its underlying dependent gems
# And we provide deprecation warnings via the Deprecation gem (extend Deprecation)
# Then we should provide a list of files with a change in Deprecation
# And provide some means for a huamn to review those changes
require 'open3'
include Open3

spec = Gem::Specification.load(File.expand_path('../../hydra.gemspec', __FILE__))
spec.runtime_dependencies.each do |dep|
  name = dep.name
  version = dep.requirement.requirements.flatten.compact.detect { |r| r.is_a?(Gem::Version) }
  repository_directory = File.expand_path("../../../#{name}", __FILE__)

  command = "cd #{repository_directory} && git log -G'extend Deprecation' v#{version}.. --stat | grep -e '| [0-9]' | cut -f 1,2 -d ' '"
  stdin, stdout, stderr, wait_thr = popen3(command)
  begin
    out = stdout.read
    err = stderr.read
    exit_status = wait_thr.value
    raise "Unable to execute command \"#{command}\"\n#{err}" unless exit_status.success?
  ensure
    stdin.close
    stdout.close
    stderr.close
  end
  if out.strip != ""
    filenames = out.split("\n").collect(&:strip).uniq
    banner = "*" * 80 << "\n"
    puts banner
    puts "Files for #{name} v#{version}"
    puts "\t" << filenames.join("\n\t")
    puts banner
    puts "See tmp/ dir for diff output"
    filenames.each do |filename|
      flat_filename = filename.gsub("/", '-')
      `cd #{repository_directory} && git diff v#{version}.. #{filename} > #{File.expand_path("../../tmp/#{flat_filename}", __FILE__)}.patch`
    end
  end
end
