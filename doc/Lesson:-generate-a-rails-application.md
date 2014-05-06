# Goals
* Create your new Ruby on Rails Application
* Initialize the local git repository for your project

# Explanation

**Note:** This lesson is roughly covers the [Getting Started](http://curriculum.railsbridge.org/curriculum/getting_started) and [Create A New Git Repo](http://curriculum.railsbridge.org/curriculum/create_a_new_git_repo) steps in the RailsBridge Curriculum.

This lesson assumes you are using a **3.2, 4.0, or 4.1 version of rails**.  To avoid confusion, it's better to have a clean gemset with only one version of rails installed.  Most people use either [RVM](http://rvm.io) or [rbenv](https://github.com/sstephenson/rbenv) to handle gemsets and ruby versions.

The first step to creating a Hydra Head, or any other type of Rails Application, is to generate the basic skeleton of the application code.

We'll also initialize our Git repository in this lesson so we can track incremental changes to our code. In order to track the changes you make to your code, to share your changes with others, and to pull other people's changes into your code, you need some form of Version Control.  The Hydra community uses Git for version control and to share work on Github.

# Steps

### Step 1: Create a new rails application

Once you have installed a suitable rails gem (any 3.2, 4.0, or 4.1 release), begin by using it to generate a new rails application.  You can choose any name for your application.  In this tutorial we are calling it hydra-demo 

```text
rails new hydra-demo
```

This generates the file structure for an empty rails application. And it runs 'bundler' which loads in all of the external dependencies for rails.

Enter the directory for the new rails app:

```text
cd hydra-demo
```

When you type `ls` at the command prompt, you should see a file structure like this:

>
```text
Gemfile		Rakefile	config.ru	lib		script		vendor
Gemfile.lock	app		db		log		test
README.rdoc	config		doc		public		tmp
```
>

### Step 1a: *(Linux only)* Enable javascript runtime

Find the line in your Gemfile that has ```# gem 'therubyracer', :platforms => :ruby``` and uncomment that line.  This allows your system to identify the appropriate javascript runtime.

Now save the Gemfile and run ```bundle install```. This tells bundler to update your dependencies to reflect the change in your Gemfile.

### Step 1b: *(Rails 3 only)* Remove the default rails 3 homepage

Rails 3 generates a placeholder homepage at `public/index.html`.  You will need to remove this file in order for the blacklight generated homepage to be used:

```text
rm public/index.html
```

### Step 2: Set your Ruby version for this project

A file called ```.ruby-version``` in your project directory (hydra-demo) identifies which version of ruby your application is built with. Put your Ruby's version inside that file. For example, if you're using ruby-2.1.1, you can create the file by entering this at the command prompt:

```text
echo 'ruby-2.1.1' > .ruby-version
```

If you're using a Ruby environment manager such as RVM or rbenv, this will cause your system to automatically load the correct version of Ruby when you enter this directory.

### Step 3: Initialize your git repository

Now, let's turn the application directory into a git repository.  Type the following:

```text
git init .
```

Then you should see something like this:

>
```text
Initialized empty Git repository in /Users/camper/hydra-demo/.git/
```
>

Next, we'll add all the files rails created into the repository.  This way we can jump back to this state later if the need arises.

```text
git add .
git commit -m "Initial rails application"
```

# Next Step
Go on to [[Lesson: Add the Hydra Dependencies]] or return to the [[Dive into Hydra]] page.