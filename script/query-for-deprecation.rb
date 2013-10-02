#!/usr/bin/env ruby -wKU

# Given that the Hydra gem is pegged against specific versions other gems
# When we update the Hydra gem and its underlying dependent gems
# And we provide deprecation warnings via the Deprecation gem (extend Deprecation)
# Then we should provide a list of files with a change in Deprecation
# And provide some means for a huamn to review those changes
require 'open3'
require 'fileutils'
include Open3

PREVIOUS_HYDRA_VERSION = 'v6.0.0'
NEXT_HYDRA_VERSION = 'v6.1.0.rc1'
DIFF_SUFFIX = 'diff'
TEMP_DIRECTORY = File.expand_path("../../tmp/", __FILE__)


class GemChange
  attr_reader :name, :previous_version, :next_version
  def initialize(name, previous_version, next_version)
    @name, @previous_version, @next_version = name, previous_version, next_version
  end

  def filenames
    @filenames ||= begin
      # Assuming that you have all of your git project hydra repos in the same parent directory
      repository_directory = File.expand_path("../../../#{name}", __FILE__)
      command = "cd #{repository_directory} && git log -G'Deprecation.warn' v#{previous_version}..v#{next_version} --stat | grep -e '| [0-9]' | cut -f 1,2 -d ' '"
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
        filenames.each do |filename|
          flat_filename = name + '-' + filename.gsub("/", '-')
          `cd #{repository_directory} && git diff v#{previous_version}..v#{next_version} #{filename} > #{File.join(TEMP_DIRECTORY, flat_filename)}.#{DIFF_SUFFIX}`
        end
        filenames
      else
        []
      end
    end
  end
end

class Changes < Array
  attr_reader :previous_version, :next_version
  def initialize(previous_version, next_version)
    @previous_version, @next_version = previous_version, next_version
  end
  def print
    $stdout.puts "Deprecation changes for Hydra #{previous_version}..#{next_version}"
    each do |change|
      $stdout.puts "\tFiles for #{change.name} v#{change.previous_version}..v#{change.next_version}"
      $stdout.puts "\t\t" << change.filenames.join("\n\t\t")
      $stdout.puts "\n"
    end
    if any?
      $stdout.puts "See tmp/ dir for diff output and review"
    end
  end
end

changes = Changes.new(PREVIOUS_HYDRA_VERSION, NEXT_HYDRA_VERSION)

previous_gemspec = File.new(File.expand_path("../../hydra-#{changes.previous_version}.gemspec", __FILE__), 'w+')
next_gemspec = File.new(File.expand_path("../../hydra-#{changes.next_version}.gemspec", __FILE__), 'w+')

begin

  system("rm #{File.join(TEMP_DIRECTORY, "*.#{DIFF_SUFFIX}")}")

  File.open(previous_gemspec.path, 'w+') do |f|
    f.write `git show #{changes.previous_version}:hydra.gemspec`
  end

  File.open(next_gemspec.path, 'w+') do |f|
    f.write `git show #{changes.next_version}:hydra.gemspec`
  end

  next_spec = Gem::Specification.load(next_gemspec.path)

  previous_spec = Gem::Specification.load(previous_gemspec.path)
  previous_spec.runtime_dependencies.each do |previous_dep|
    # Skipping rails as we don't want to manage those deprecation dependencies
    next if previous_dep.name == 'rails'
    next_dep = next_spec.runtime_dependencies.detect { |d| d.name == previous_dep.name }
    gem_name = previous_dep.name

    previous_version = previous_dep.requirement.requirements.flatten.compact.detect { |r| r.is_a?(Gem::Version) }
    next_version = next_dep.requirement.requirements.flatten.compact.detect { |r| r.is_a?(Gem::Version) }

    changes << GemChange.new(gem_name, previous_version, next_version)
  end
ensure
  File.unlink(previous_gemspec.path) if File.exist?(previous_gemspec.path)
  File.unlink(next_gemspec.path) if File.exist?(next_gemspec.path)
end

changes.print
