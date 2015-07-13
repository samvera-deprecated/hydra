# Goals
* Add the Hydra software to your application's list of dependencies
* Add Hydra (Hydra, Blacklight, and Devise) functionality to your Rails Application

# Explanation 

In order to take advantage of the Hydra code and features in your application, you need to tell the application where to find that code and which versions of that code to use.  Rails uses a tool called [bundler](http://bundler.io/) to track dependencies.  Bundler looks in the file called `Gemfile` to know what you want installed.

Hydra builds on and extends the features provided by Blacklight, the hydra generator integrates core hydra and blacklight functionality into your application.  To do this, we run the custom [Rails generator](http://guides.rubyonrails.org/generators.html) provided by the hydra gem.  The generator creates a number of files in your application that will allow you to build a Hydra application and use and modify Blacklight's features in your application.  The default generator also installs [devise](https://github.com/plataformatec/devise) to provide simple user authentication and management.

# Steps

### Step 1: Add the *hydra* gem to your Gemfile

Open up `Gemfile` in your editor.   We're going to add the following lines after the `source` line:

```ruby
gem 'hydra'
gem 'hydra-head'
```

This includes the hydra-gem in our application.  Bundler will then ensure that the hydra-head, blacklight, active-fedora and other gems required by hydra get included (required) correctly. This includes a dependency for the jettywrapper gem (installed automatically). The jettywrapper gem is used to install and configure a preconfigured instance of jetty that loads and runs local development instances of Fedora and Solr for you to run and test your application against.

Now save the change and install the dependencies by running bundler:
```text
bundle install
```

Check which files have been changed:
```text
git status
```

You should see changes to your `Gemfile` and `Gemfile.lock`.  Now, go ahead and commit the modified files to your local git repo:
```text
git add .
git commit -m "Add hydra dependency to Gemfile"
```

### Step 2: Run the code generator provided by the *hydra* gem.

>
**Tip:** If you want to see clearly what changes that the generator makes, make sure that all of your current changes have been checked into git before running the generator. I.E. make sure that `git status` reports that there are no changes ("nothing to commit").  Then, after you run the generator, you can list all of the newly created and modified field by running `git status`.
>

Run the hydra generator

```text
rails generate hydra:install
```

The hydra generator invokes both the blacklight generator and the hydra-head generator.  Additionally, the blacklight generator installed the devise gem and the bootstrap gem.  It's created an important file in our application `app/controllers/catalog_controller.rb`.  This is the primary place where you configure the blacklight search.

When they are done, the generators have created a few database migrations that support saving user data, searches and bookmarks. Normally you would have to run `rake db:migrate` to update your database tables, but the hydra installer does this for you as one of its last steps.

### Step 3: Review and commit your changes

See what the hydra generator has done
```text
git status
```

After you've viewed which files have been modified, commit the changes:

```text
git add .
git commit -m "Ran hydra generator"
```

# Next Step
Go on to [[Lesson: Install hydra-jetty]] or return to the [[Dive into Hydra]] page.
