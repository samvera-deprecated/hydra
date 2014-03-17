# Updating Hydra gem procedure

## Deprecations

### Indicating Deprecations

Each of the ProjectHydra gems in hydra.gemspec make use of the [`deprecation`
gem](https://github.com/cbeer/deprecation). Below is our preferred method for
indicating deprecation:

    class Foo
      def bar
        Deprecation.warn(Foo, 'Foo#bar is deprecated. Please use Baz', caller)
        …
      end
    end

By adhearing to the above deprecation semantic we are able to report
deprecations when the Hydra gem is updated.

### Reporting Deprecations on Hydra upgrades

The `./script/query-for-deprecation.rb` is a tool to help report what methods
have had a change in deprecation status.

## Documentation for releases

Our primary location for documentation is the Github wiki associated with this
project. All pages from the Github wiki should be copied to `doc/` as part of
a release.

**Steps:**

1. Get the latest version of the wiki. Note that Github wikis are git
repositories, so you can treat them like any other.

	```
	# if you haven't yet done so, clone the wiki repo...
	git clone git@github.com:projecthydra/hydra.wiki.git path/to/hydra.wiki

	# or, if you have already cloned, then get the latest changes...
	cd path/to/hydra.wiki
	git pull
	```

1. Copy the wiki pages to `docs/` directory of `hydra` project.

	```
	cp -a path/to/hydra.wiki/* path/to/hydra/docs/
	```

1. Commit the changes.

	```
	cd path/to/hydra
	git add docs/.
	git commit -m "Updates the wiki docs"
	```

This commit should then be included as part of the pull request for the new
release. See ["Making Changes"](/CONTRIBUTING.md#making-changes) and
["Submitting Changes"](/CONTRIBUTING.md#submitting-changes) on the preferred
way to submit pull requests.
properly.