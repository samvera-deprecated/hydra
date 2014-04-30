# Goals
* Create your new Ruby on Rails Application

# Explanation

**Note:** This lesson is basically equivalent to the [Getting Started](http://curriculum.railsbridge.org/curriculum/getting_started) step in the RailsBridge Curriculum.

This lesson assumes you are using a **3.2 or 4.0 version of rails**.  To avoid confusion, it's better to have a clean gemset with only one version of rails installed.  Most people use either [RVM](http://rvm.io) or [rbenv](https://github.com/sstephenson/rbenv) to handle gemsets and ruby versions.

The first step to creating a Hydra Head, or any other type of Rails Application, is to generate the basic skeleton of the application code.

# Steps

### Step 1: Create a new rails application

Once you have installed a suitable rails gem (any 3.2 or 4.0 release), begin by using it to generate a new rails application.  You can choose any name for your application.  In this tutorial we are calling it hydra-demo 

```bash
$> rails new hydra-demo
```

This generates the file structure for an empty rails application. And it runs 'bundler' which loads in all of the external dependencies for rails.

Enter the directory for the new rails app: ```cd hydra-demo```, then you should see a file structure like this:

```bash
$> ls
Gemfile		Rakefile	config.ru	lib		script		vendor
Gemfile.lock	app		db		log		test
README.rdoc	config		doc		public		tmp
```

### Step 2: Set your Ruby version for this project

Create the file ```.ruby-version``` in your project's directory (hydra-demo). Put your Ruby's version inside that file. For example, if you're using ruby-2.0.0, your file would look like this:

```text
2.0.0
```

If you're using a Ruby environment manager such as RVM or rbenv, this will make it so you switch to the correct version of Ruby when you enter this directory.

> ### Linux only step: Enable javascript runtime
>
> Find the line in your Gemfile that has ```# gem 'therubyracer', :platforms => :ruby``` and uncomment that line.  This allows your system to identify the appropriate javascript runtime.
>
> Now save the Gemfile and run ```bundle install```. This tells bundler to update your dependencies to reflect the change in your Gemfile.

# Next Step
Go on to [[Lesson: Create a git Repository]] or return to the [[Dive into Hydra]] page.