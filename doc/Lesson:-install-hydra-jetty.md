This lesson is known to work with hydra release version 6.1.0, 6.2.0.   
_Please update this wiki to reflect any other versions that have been tested._

# Goals
* Install a copy of hydra-jetty, which includes pre-configured copies of Fedora and Solr

# Explanation
In order to use blacklight and hydra-head, you need an installation of Solr.  Additionally, hydra-head requires a copy of the Fedora repository.  We have created a package called hydra-jetty, which provides both of these within a Jetty Java application server.

# Steps


### Step 1: Install the hydra-jetty package 

Use the hydra:jetty generator to install the hydra-jetty package by running:

```bash
$> rails g hydra:jetty
```

This generator is provided by the jettywrapper gem.


This can be very slow (over 100Mb of download).  When it's done you'll see the directory named ```jetty``` has been created. If you run '''git status''' you will see 

```text
# On branch master
# Untracked files:
#   (use "git add <file>..." to include in what will be committed)
#
#	jetty/
```

**Windows Tip**:  Currently this rake task doesn't work on Windows (see [jettywrapper issue #14](https://github.com/projecthydra/jettywrapper/issues/14) for status).  Workaround: Download https://github.com/projecthydra/hydra-jetty/archive/v7.0.0.zip, unpack it, and move the unpacked 'jetty' directory to the root of your application.

### Step 2: Make git ignore the jetty directory

We want git to ignore the jetty directory for the same reasons that we don't check our development databases into git -- because it's big and bulky and you don't actually need other developers to have exact copies of your jetty as long as they have all the other code. 

We do that by editing ```.gitignore``` and adding the something like this:

```text
# Ignore jetty directory (from hydra-jetty)
/jetty

```

Now commit this change

```
git add .gitignore
git commit -m "Adds /jetty to .gitignore"
```


# Next Step
Go on to [[Lesson: Start Jetty]] or return to the [[Dive into Hydra]] page.