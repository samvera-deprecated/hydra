# Goals
* Install FCRepo and Solr
* Learn to start and stop FCRepo and Solr

# Explanation
In order to use blacklight and hydra-head you need an installation of Solr.  In addition, hydra-head requires a copy of Fedora.  Fedora and Solr are both Java web applications.

For developer environments, we have created a `solr_wrapper` and `fcrepo_wrapper` -- commands to assist you in starting Solr and Fedora. Whenever you need Fedora and Solr running in your development environment, just start or stop that copy of `solr_wrapper` or `fcrepo_wrapper`

>
**TIP** *DO NOT* use `solr_wrapper` or `fcrepo_wrapper` for production installations.
>

>
**WORKSHOPS & HYDRA CAMP** if you're using a VM provided for the workshop, there's probably a copy of solr and fedora already on your VM, follow the instructions your facilitator provides to copy the files instead of having to download them again.  Probably something like
```
cp ~/downloads/solr-5.4.1.zip /tmp
cp ~/downloads/fcrepo-webapp-4.5.0-jetty-console.jar /tmp
```
>

### Step 1: Start Solr 
Open a new terminal window and type:
```
cd <hydra-demo app path>
solr_wrapper -d solr/config/ --collection_name hydra-development
```

You can check to see if Solr is started by going to [[http://localhost:8983/]]

>
**TIP** Running solr_wrapper in a tmux panel can silently fail. Use a separate new terminal window, or install https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard for Mac OSX.
>



### Step 2: Start FCRepo
Open a new terminal window and type:

```
fcrepo_wrapper -p 8984
```

You can check to see if FCRepo is started by going to [[http://localhost:8984/]]

### Step 3: Make git ignore the `fcrepo4-data` directory

We want git to ignore the `fcrepo4-data` directory for the same reasons that we don't check our development databases into git -- because it's big and bulky and you don't actually need other developers to have exact copies of your data as long as they have all the other code. 

We do that by editing `.gitignore` and adding the something like this:

```text
# Ignore Fedora data files
/fcrepo4-data

```

Now commit this change

```text
git add .gitignore
git commit -m "Adds /fcrepo4-data to .gitignore"
```

#### FYI: Stopping FCRepo and Solr
In order to stop either service, open the window they are running in and type `<Control>-C`. Wait a few moments for the process to terminate.


>
**Tip:** Sometimes people are confused about whether they need to restart Fedora or Solr when they restart their Rails application.  In most cases it is fine to leave Fedora and Solr running when you start, stop, and restart the Rails application.  The only exception is when you make changes to Solr's configuration or Fedora's configuration -- these would be changes to files inside of your copy of the solr configuration (i.e. solr/config), not changes to files in your Rails application's Ruby code.  In those cases, where you have made changes to Solr or Fedora's configuration, you need to restart the processes in order for those changes to take effect.  The most common change that requires restarting Solr is when you modify the solrconfig.xml or schema.xml in your solr config directory. Normally, changes to your data steams or models do not require restarts to Solr and Fedora because these changes are indexed dynamically by Hydra.
> 



# Next Step
Go on to [[Lesson - Start the Application & Search for Results]] or return to the [[Dive into Hydra]] page.