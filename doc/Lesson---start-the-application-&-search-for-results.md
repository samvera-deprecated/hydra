# Goals
* Configure the application
* Start and Stop a local "development" copy of the application
* Remove the default Welcome page provided by Rails
* Run a Search in Blacklight through your browser

# Steps

### Step 1: Configure the application

There are a couple configurations that need to be set, or verified, before starting the application. 

#### config/solr.yml
The urls and collection name must be set to match what is running by solr_wrapper.
``` 
development:
  url: http://127.0.0.1:<%= ENV['SOLR_TEST_PORT'] || 8983 %>/solr/hydra-development
```

#### config/fedora.yml
The urls to the Fedora server must be properly set for production and what is running by fcrepo_wrapper.
```
development:
  url: http://127.0.0.1:<%= ENV['FCREPO_DEVELOPMENT_PORT'] || 8984 %>/rest
  ...
```

### Step 2: Start the Rails server

Now, let's see our model on the web.  You can start 'webrick', a development server that comes with rails by typing:

```bash
rails server -b 0.0.0.0
```

>
*NOTE:* -b 0.0.0.0 isn't strictly required, but lets you access your server from your host browser if you're running it in a VM
>

Leave this terminal window open through the rest of the tutorial.  It will print info whenever the server does anything.  You will return to this window when you want to stop or restart the server.

### Step 3: Look at the application in your Browser and customize the home page

Now you can visit your local copy of the application with a web browser when you go to [[http://localhost:3000/]].

The default home page gives instructions for customizing the home page: essentially, create a ```app/views/catalog/_home_text.html.erb``` with the content you want. After saving that file and reloading in the browser you should see your changes.
 
### Step 4: Run a Search

If you enter a search query you don't see any results because we haven't created any objects yet -- your Solr index is empty.

In the next lessons we will create a objects in your Fedora repository, then we will show you how to make them appear in your search results.

# Next Step
If you're interested in how RDF object modeling works, go on to [[Lesson - Build a book model with RDF]]; otherwise go on to [[Lesson - Build a codex model with XML]] or return to the [[Dive into Hydra]] page.