This lesson is known to work with hydra (gem) version 6.1.0.   
_Please update this wiki to reflect any other versions that have been tested._

# Goals
* Add the Hydra software to your application's list of dependencies
* Use bundler to install dependencies

# Explanation 

In order to take advantage of the Hydra code and features in your application, you need to tell the application where to find that code and which versions of that code to use.  Rails uses a tool called [bundler](http://bundler.io/) to track dependencies.  Bundler looks in the file called `Gemfile` to know what you want installed.

# Steps

Open up ```Gemfile``` in your editor.   We're going to add the following lines:

```ruby
gem 'hydra', require: 'hydra6'
```

This declares our application to have a dependency on the hydra6 release version of the hydra-gem and ensures that the hydra-head gem gets included (required) correctly. This includes a dependency for the jettywrapper gem (installed automatically). The jettywrapper gem is used to install and configure a preconfigured instance of jetty that loads and runs local development instances of Fedora and Solr for you to run and test your application against.

Now we save the file and install the dependencies by running bundler:
```text
$ bundle install
```

# Next Step
Go on to [[Lesson: Run the Hydra generator]] or return to the [[Dive into Hydra]] page.