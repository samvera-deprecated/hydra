This lesson is known to work with hydra version 6.1.0, 6.2.0.   
_Please update this wiki to reflect any other versions that have been tested._

# Goals
* Add Hydra (Hydra, Blacklight, and Devise) functionality to your Rails Application

# Explanation

Hydra builds on and extends the features provided by Blacklight, the generator integrates core hydra and blacklight functionality into your application.  To do this, we run the custom [Rails generator](http://guides.rubyonrails.org/generators.html) provided by the hydra gem.  The generator creates a number of files in your application that will allow you to build a Hydra application and use and modify Blacklight's features in your application.  The default generator also installs [devise](https://github.com/plataformatec/devise) to provide simple user authentication and management.

**Tip:** If you want to see clearly what changes that the generator has made, make sure that before you run the generator all of your current changes have been checked into git -- so before running the generator running 'git status' should report that there are no changes ("nothing to commit").  Then when you run the generator you will be able to see all of the changes it's made by runing 'git status'.

# Steps

**Note:** You must have completed the steps in [[Lesson: Add the Hydra Dependencies]] in order for the following steps to work.


### Step 1: Run the code generator provided by the Hydra gem.  

We do this by typing 

```bash
$> rails generate hydra:install
```

The hydra generator invokes both the blacklight generator and the hydra-head generator.  Additionally, the blacklight generator installed the devise gem and the bootstrap gem.  It's created an important file in our application `app/controllers/catalog_controller.rb`.  This is the primary place where you configure the blacklight search.

When they are done, the generators have created a few database migrations that support saving user data, searches and bookmarks. Normally you would have to run `rake db:migrate` to update your database tables, but the hydra installer does this for you as one of its last steps.

### Step 2: Commit your changes
At this point it's a good idea to commit the changes:

```bash
$> git add .
$> git commit -m "Ran hydra generator"
```

# Next Step
Go on to [[Lesson: Install hydra-jetty]] or return to the [[Dive into Hydra]] page.