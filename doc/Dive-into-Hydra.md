This tutorial is known to work with [hydra](http://rubygems.org/gems/hydra) release version 6.1.0.   
_Please update this wiki to reflect any other versions that have been tested._

# Prerequisites

This tutorial assumes that you have some basic familiarity with Ruby and Rails.  If you are new to Rails, we recommend going through the [RailsBridge Tutorial](http://curriculum.railsbridge.org/intro-to-rails/) first.

A fun way to learn about the basic Rails syntax and patterns is the [Rails for Zombies](http://railsforzombies.org/) tutorial.

The tutorial also mentions using [Ruby Version Manager](http://rvm.io), a.k.a RVM.  Before starting this tutorial, visit the [RVM website](http://rvm.io/) to learn about how that tool is used.  RVM is not required in order to do the tutorial, but you will probably find it useful.

# System Requirements
Your system should have the following installed before beginning the walkthrough
+ [ruby](http://www.ruby-lang.org/en/) 1.9.3 or 2.0.0
+ [rails](http://rubyonrails.org/)  ~>3.2.15 or ~>4.0.0
+ [git](http://git-scm.com/)
+ [java](http://www.java.com/en/) runtime >= 6.0 

# Goals
* Create a Hydra Head
* Run Fedora and Solr underneath the Hydra Head
* Start & Stop the Application
* Start & Stop Fedora and Solr
* Define Models for Content to put into your Hydra Head (in this case Books and Pages)
* Use your Models to Create objects in Fedora and Solr
* See where content is persisted in Fedora and indexed in Solr
* Modify how metadata is indexed in Solr
* Use Git to Track Code Changes

# Steps/Lessons
1. [[Lesson: Generate a Rails Application]]
1. [[Lesson: Create a git Repository]]
1. [[Lesson: Add the Hydra Dependencies]]
1. [[Lesson: Run the Hydra generator]]
1. [[Lesson: Install hydra-jetty]]
1. [[Lesson: Start Jetty]]
1. [[Lesson: Start the Application & Search for Results]]
1. [[Lesson: Build a Book Model]]
1. [[Lesson: Turn Off Access Controls]]
1. [[Lesson: Make Blacklight Return Search Results]]

## Bonus
You've completed the main tutorial, the following lessons can be completed in any order based on your interests:  

1. [[Lesson: Define Relationships Between Objects]]  
1. [[Lesson: Adding Content Datastreams]]  
1. [[Lesson: Generate Rails Scaffolding for Creating and Editing Books]]  
1. [[Lesson: Set up your Rails Application to use RSpec]]  

# Next Steps
You've finished the initial Hydra tutorial and learned about setting up the basic hydra framework, building basic data models, establishing relationships between models, and modifying the basic user interface provided in a default hydra install.  There is still lots more to learn.  At this point, you can explore the ideas in this tutorial further by spending some time building out your models to support more complex metadata, further customizing your application views, and/or adding tests to make your applications more robust and easy to maintain.

There's lots more Hydra though, so you may wan to check out the following tutorials
- [Tame Your XML With OM](https://github.com/projecthydra/om/wiki/Tame-your-XML-with-OM) shows you how to configure Hydra to parse metadata from source XML documents
- [Access Controls with Hydra](https://github.com/projecthydra/hydra-head/wiki/Access-Controls-with-Hydra) teaches you to configure roles and access rights that determine which content can be viewed by various user roles assigned to users of your repository
- Even though the information there is not specific to Hydra, [Getting Started with Rails](http://guides.rubyonrails.org/getting_started.html) is a great place to learn more about Model, View, and Controller conventions within Rails that can be applied to building your own Hydra-based repository.

You should also say hello on the [hydra-tech mailing list](https://groups.google.com/forum/?fromgroups#!forum/hydra-tech) and let us know what you're using Hydra for.  
  
Check out the Hydra Project Website at [http://projecthydra.org](http://projecthydra.org)  

![Project Hydra Logo](https://github.com/uvalib/libra-oa/blob/a6564a9e5c13b7873dc883367f5e307bf715d6cf/public/images/powered_by_hydra.png?raw=true)