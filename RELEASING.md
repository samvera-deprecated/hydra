# Releasing Hydra Gems

* [Semantic Versioning](#semantic-versioning)
* Release Candidates
* How to Do It
  * Major release
  * Minor release
  * Patch release

## Semantic Versioning

We use semantic versioning.

> Given a version number MAJOR.MINOR.PATCH, increment the:
> MAJOR version when you make incompatible API changes,
> MINOR version when you add functionality in a backwards-compatible manner, and
> PATCH version when you make backwards-compatible bug fixes.
> Additional labels for pre-release and build metadata are available as extensions to the MAJOR.MINOR.PATCH format.
> – [semver.org](http://semver.org)

## Release Candidates

Both Major and Minor releases should have release candidates.

| Task                                                          | Major | Minor | Patch |
|---------------------------------------------------------------|-------|-------|-------|
| Synchronize Local Repository                                  | Yes   | Yes   | Yes   |
| Create Release Candidate                                      | Yes   | Yes   | No    |

## Process for Releasing the Gem or Gems

Each of the gems in Project Hydra may be a bit different.
Most will follow two flavors:

* A repository with one gem (e.g. [active_fedora](https://github.com/projecthydra/active_fedora) and [rubydora](https://github.com/projecthydra/rubydora))
* A repository with multiple gems (e.g. [hydra-head](https://github.com/projecthydra/hydra-head) and [sufia](https://github.com/projecthydra/sufia))

In either case there are a few common steps to take.

### Sanity Check

Before you go any further, make sure you have:

* Rights to publish the gem on Rubygems.org.
* Rights to push changes to the Github repository.

For Rubygems, go to `https://rubygems.org/gems/<name_of_gem>` and make sure you are one of the authors/owners.

For Github, make sure you are setup for collaboration. Check the Github project's Settings > Collaborators section.
If you are not, you will not be able to publish the gem.

### Synchronize Local Repository

**Warning** This will destroy any commits and work that is in your local `<deploy_branch>` branch but not in the `<remote_name>` remote. In other words, make sure any of your commits that you want to keep are in another branch.

2. Run `$ git checkout <deploy_branch>`.
3. Run `$ git status` as a sanity check to make sure you aren't about to lose something.
4. Run `$ git fetch <remote_name> --tags`.
5. Run `$ git reset --hard origin/<deploy_branch>`.

In most cases the `<deploy_branch>` will be `master` and the `<remote_name>` will be `origin`.

Some projects may deploy from a branch other than `master`.
Read the projects README for additional information about which branch is the release.

The `<remote_name>` is a configuration option for your local repository. By default the first remote will be origin.
Run `$ git remote --verbose` to see all of the registered remotes.
