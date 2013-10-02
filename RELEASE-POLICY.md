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
