This lesson is known to work with hydra release version 6.1.0, 6.2.0.   
_Please update this wiki to reflect any other versions that have been tested._

# Goals
* Start and Stop Jetty (which contains Fedora and Solr)

# Explanation
Fedora and Solr are both Java web applications that need to run in a servlet container like Tomcat or Jetty.  We installed hydra-jetty in the [[Lesson: Install hydra-jetty]].  Now whenever you need Fedora and Solr running, just start or stop that copy of hydra-jetty.

**Tip:** Sometimes people are confused about whether they need to restart jetty when they restart their Rails application.  In most cases it is fine to leave jetty running when you start, stop, and restart the Rails application.  The only exception is when you make changes to Solr's configuration or Fedora's configuration -- these would be changes to files inside of your copy of hydra-jetty (ie. jetty/solr/config), not changes to files in your Rails application's Ruby code.  In those cases, where you have made changes to Solr or Fedora's configuration, you need to restart Jetty in order for those changes to take effect.  The most common change that requires restarting jetty is when you modify the solrconfig.xml or schema.xml in your solr config directory.

# Steps

### Step 1: Start Jetty
At the project root, type 

```bash
$> rake jetty:start
```

You should see output like this:

```text
Starting jetty with these values: 
jetty_home: /Users/justin/hydra-demo/jetty
jetty_command: java -Djetty.port=8983 -Dsolr.solr.home=/Users/justin/hydra-demo/jetty/solr -Xmx256m -XX:MaxPermSize=128m -jar start.jar
Logging jettywrapper stdout to /Users/justin/hydra-demo/jetty/jettywrapper.log
Wrote pid file to /Users/justin/hydra-demo/tmp/pids/_Users_justin_hydra-demo_jetty.pid with value 8315
Waited 5 seconds for jetty to start, but it is not yet listening on port 8983. Continuing anyway.
Started jetty (5575.9ms)
```

hydra-jetty has a fair amount of stuff in it, so it may take up to a minute to start.  You can check to see if it's started by going to [[http://localhost:8983/solr]]

If Fedora, Solr, or jetty itself are not starting, you'll want to look at the jettywrapper log to diagnose.

**Windows Tip:** This rake task is not currently working on Windows (see [jettywrapper issue #13](https://github.com/projecthydra/jettywrapper/issues/13) for status).  In the meantime, start jetty manually
```
cd jetty
java -Djetty.port=8983 -Dsolr.solr.home=/Users/justin/hydra-demo/jetty/solr -Xmx256m -XX:MaxPermSize=128m -jar start.jar
```

### Step 2: Look at the jettywrapper log

The jetty:start rake task runs jetty as a background job, so jetty's logs won't appear in your terminal.  Instead they're written to the file ```jetty/jettywrapper.log```.  If you look at the output from running the jetty:start task, you'll see that one line gives you the full path to the file, for example:

```text
Logging jettywrapper stdout to /Users/justin/hydra-demo/jetty/jettywrapper.log
```

You can open this log file with any text editor or log reader.

```bash
$> vi jetty/jettywrapper.log
```

### Step 3: Monitor the jettywrapper log


**Tip:** if jetty is taking a long time to start, you can watch its output using the tail command with the path to your jettywrapper.log.  For example:

```bash
$> tail -f jetty/jettywrapper.log
```

As Jetty, Fedora, and Solr start you will see more info being written to the log file. After a few moments you will be able to open jetty at [[http://localhost:8983]] or [[http://0.0.0.0:8983]] (**note:** The root page will give a 404 error, but should have three links to the applications running in Jetty: /solr, /fedora and /fedora-test)

### Step 4: Stop Jetty
You might have guessed this one.  In order to stop jetty, at the project root, type

```bash
$> rake jetty:stop
```

### Step 5: Start Jetty again
Before proceeding to the next step, make sure jetty is running.  If you're not sure whether it's running, go to http://localhost:8983.  If jetty is running a page will load.  If jetty is not running no page will load.

If it's not running, just use the jetty:start rake task again.

```bash
$> rake jetty:start
```

# Next Step
Go on to [[Lesson: Start the Application & Search for Results]] or return to the [[Dive into Hydra]] page.