# Goals
* Install a copy of hydra-jetty, which includes pre-configured copies of Fedora and Solr
* Learn to start and stop hydra-jetty (which contains Fedora and Solr)

# Explanation
In order to use blacklight and hydra-head, you need an installation of Solr.  In addition, hydra-head requires a copy of Fedora.  Fedora and Solr are both Java web applications that need to run in a servlet container like Tomcat or Jetty. 

For developer environments, we have created a package called hydra-jetty which provides both services pre-installed within a Jetty Java application server. Whenever you need Fedora and Solr running in your development environment, just start or stop that copy of hydra-jetty.

>
**TIP** *DO NOT* use hydra-jetty for production installations.  The hydra-jetty passwords are well-known and the installation has not been secured for non-local use.
>

# Steps

### Step 1: Install the hydra-jetty package 

Use the hydra:jetty generator to install the hydra-jetty package by running:

>
**TIP** hydra-jetty is a very large download.  If you are completing this lesson as part of a workshop, the facilitator may have a copy of hydra-jetty that you can load from a flash-drive rather than downloading over the internet. The workshop facilitator will provide alternate instructions for this step.
>

```text
rails g hydra:jetty
```

Note: this requires that your system have curl installed. If it does not, you may see an unhelpful error:

```text
Unable to download jetty from https://github.com/projecthydra/hydra-jetty/archive/v7.0.0.zip
```

This generator is provided by the jettywrapper gem.


This can be very slow (over 100Mb of download).  When it's done you'll see the directory named `jetty` has been created. If you run `git status` you will see 

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

We do that by editing `.gitignore` and adding the something like this:

```text
# Ignore jetty directory (from hydra-jetty)
/jetty

```

Now commit this change

```text
git add .gitignore
git commit -m "Adds /jetty to .gitignore"
```

### Step 3: Start Jetty
At the project root, type 

```text
rake jetty:start
```

You should see output like this:

>
```text
Starting jetty with these values: 
jetty_home: /Users/justin/hydra-demo/jetty
jetty_command: java -Djetty.port=8983 -Dsolr.solr.home=/Users/justin/hydra-demo/jetty/solr -Xmx256m -XX:MaxPermSize=128m -jar start.jar
Logging jettywrapper stdout to /Users/justin/hydra-demo/jetty/jettywrapper.log
Wrote pid file to /Users/justin/hydra-demo/tmp/pids/_Users_justin_hydra-demo_jetty.pid with value 8315
Waited 5 seconds for jetty to start, but it is not yet listening on port 8983. Continuing anyway.
Started jetty (5575.9ms)
```
>

hydra-jetty has a fair amount of stuff in it, so it may take up to a minute to start.  You can check to see if it's started by going to [[http://localhost:8983/solr]]

If Fedora, Solr, or jetty itself are not starting, you'll want to look at the jettywrapper log to diagnose.

**Windows Tip:** This rake task is not currently working on Windows (see [jettywrapper issue #13](https://github.com/projecthydra/jettywrapper/issues/13) for status).  In the meantime, start jetty manually

```text
cd jetty
java -Djetty.port=8983 -Dsolr.solr.home=/Users/justin/hydra-demo/jetty/solr -Xmx256m -XX:MaxPermSize=128m -jar start.jar
```

### Step 4: Look at the jettywrapper log

The jetty:start rake task runs jetty as a background job, so jetty's logs won't appear in your terminal.  Instead they're written to the file `jetty/jettywrapper.log`.  If you look at the output from running the jetty:start task, you'll see that one line gives you the full path to the file, for example:

```text
Logging jettywrapper stdout to /Users/justin/hydra-demo/jetty/jettywrapper.log
```

You can open this log file with any text editor or log reader.

```text
vi jetty/jettywrapper.log
```

### Step 5: Monitor the jettywrapper log

>
**Tip:** if jetty is taking a long time to start, you can watch its output using the tail command with the path to your jettywrapper.log.  For example:

```text
tail -f jetty/jettywrapper.log
```
>

As Jetty, Fedora, and Solr start you will see more info being written to the log file. After a few moments you will be able to open jetty at [[http://localhost:8983]] or [[http://0.0.0.0:8983]] (**note:** The root page will give a 404 error, but should have three links to the applications running in Jetty: /solr, /fedora and /fedora-test)

### Step 6: Stop Jetty
You might have guessed this one.  In order to stop jetty, at the project root, type

```text
rake jetty:stop
```

### Step 7: Start Jetty again
Before proceeding to the next lesson, make sure jetty is running.  If you're not sure whether it's running, go to http://localhost:8983.  If jetty is running a page will load.  If jetty is not running no page will load.

If it's not running, just use the jetty:start rake task again.

```text
rake jetty:start
```


>
**Tip:** Sometimes people are confused about whether they need to restart jetty when they restart their Rails application.  In most cases it is fine to leave jetty running when you start, stop, and restart the Rails application.  The only exception is when you make changes to Solr's configuration or Fedora's configuration -- these would be changes to files inside of your copy of hydra-jetty (ie. jetty/solr/config), not changes to files in your Rails application's Ruby code.  In those cases, where you have made changes to Solr or Fedora's configuration, you need to restart Jetty in order for those changes to take effect.  The most common change that requires restarting jetty is when you modify the solrconfig.xml or schema.xml in your solr config directory.
>

# Next Step
Go on to [[Lesson: Start the Application & Search for Results]] or return to the [[Dive into Hydra]] page.
