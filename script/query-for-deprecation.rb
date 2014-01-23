#!/usr/bin/env ruby -KU

# Given that the Hydra gem is pegged against specific versions other gems
# When we update the Hydra gem and its underlying dependent gems
# And we provide deprecation warnings via the Deprecation gem (extend Deprecation)
# Then we should provide a list of files with a change in Deprecation
# And provide some means for a huamn to review those changes
require 'open3'
require 'fileutils'
include Open3

PREVIOUS_HYDRA_VERSION = 'v6.0.0'
NEXT_HYDRA_VERSION = 'v6.1.0'
DIFF_SUFFIX = 'diff'
TEMP_DIRECTORY = File.expand_path("../../tmp/", __FILE__)


class GemChange
  attr_reader :name, :previous_version, :next_version
  def initialize(name, previous_version, next_version)
    @name, @previous_version, @next_version = name, previous_version, next_version
  end

  def with_projecthydra_changes
    url = github_project_url
    if url && commit_ids.any?
      yield(url, commit_ids)
    end
  end

  def commit_ids
    @commit_ids ||= begin
      # Assuming that you have all of your git project hydra repos in the same parent directory
      command = "cd #{repository_directory} && git log -G'deprecat' -i v#{previous_version}..v#{next_version} --pretty=format:%H"
      output = execute_command(command)
      if output.strip != ""
        output.split("\n").collect(&:strip).uniq
      else
        []
      end
    end
  end

  protected

  def github_project_url
    command = "cd #{repository_directory} && git config --get remote.origin.url"
    remote_url = execute_command(command).strip
    if remote_url =~ /projecthydra/
      remote_url.sub(/\A.*projecthydra\/([\w-]*).*\Z/, 'https://github.com/projecthydra/\1')
    elsif remote_url =~ /projectblacklight/
      remote_url.sub(/\A.*projectblacklight\/([\w-]*).*\Z/, 'https://github.com/projectblacklight/\1')
    else
      nil
    end
  end

  def repository_directory
    File.expand_path("../../../#{name}", __FILE__)
  end

  def execute_command(command)
    stdin, stdout, stderr, wait_thr = popen3(command)
    begin
      out = stdout.read
      err = stderr.read
      exit_status = wait_thr.value
      raise "Unable to execute command \"#{command}\"\n#{err}" unless exit_status.success?
      out
    ensure
      stdin.close
      stdout.close
      stderr.close
    end
  end
end

class Changes < Array
  attr_reader :previous_version, :next_version
  def initialize(previous_version, next_version)
    @previous_version, @next_version = previous_version, next_version
  end
  def print
    $stdout.puts "Deprecation changes for Hydra #{previous_version}..#{next_version}\n\n"
    each do |change|
      change.with_projecthydra_changes do |github_project_url, commit_ids|
        $stdout.puts "\tCommits for #{change.name} v#{change.previous_version}..v#{change.next_version}"
        change.commit_ids.each do |commit_id|
          $stdout.puts "\t\t" << commit_id << "\t" << File.join(github_project_url, 'commit', commit_id)
        end
        $stdout.puts "\n"
      end
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
