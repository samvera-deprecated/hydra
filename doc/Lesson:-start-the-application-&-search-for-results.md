# Goals
* Start and Stop a local "development" copy of the application
* Remove the default Welcome page provided by Rails
* Run a Search in Blacklight through your browser

# Steps

### Step 1: Start the Rails server

Now, let's see our model on the web.  You can start 'webrick', a development server that comes with rails by typing:

```bash
$> rails server
```

Leave that terminal window open.  It will print info whenever the server does anything.  You will return to this window when you want to stop or restart the server.

### Step 2: Look at the application in your Browser

Now you can visit your local copy of the application with a web browser when you point the browser at [[http://localhost:3000/]]
 
### Step 3: Run a Search

Now that you've removed the default "Welcome" page and reloaded the page in your browser, you should see something that looks like a default Blacklight install.  If you enter a search query you don't see any results because we haven't created any objects yet -- your Solr index is empty.

In the next step we will create a Book object that will then show up in your search results.

# Next Step
Go on to [[Lesson: Build a Book Model]] or return to the [[Dive into Hydra]] page.