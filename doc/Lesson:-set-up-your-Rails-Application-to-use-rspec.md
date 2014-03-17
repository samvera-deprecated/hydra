This Tutorial is known to work with hydra version 6.1.0.  
_Please update this wiki to reflect any other versions that have been tested._

# Goals

* Set up a Rails application to use RSpec

# Explanation
We strongly recommend building a habit of using Test Driven Development.  Most people using Hydra use RSpec for Test Driven Development.  Also, RSpec tests are required with any contributions to any of the core Hydra gems.  Here's how to set up your Rails application to use RSpec for testing.

# Steps

### Step 1: Install the rspec and rspec-rails gems

Ensure your Gemfile includes `rspec-rails`, e.g.:
```ruby
group :development, :test do
  gem "rspec-rails"
end
```
If you had to add `rspec-rails`, run bundle install
```bash
$ bundle install
```

### Step 2: Run the rspec rails generator

On the Command line
```text
rails generate rspec:install
```

### Step 3: Commit your changes

```text
git add .
git commit -m"added rspec"
```

# Next Steps
Return to the [[Dive into Hydra]] page.