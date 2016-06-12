# Goals
* *(for now)* Turn off access controls for Blacklight-based searches and "show" views 
* Tell Blacklight which fields to use in searches
* Run a search in Blacklight and see results rendered

# Explanation

In [[Lesson - Build a book model with RDF]] and/or [[Lesson - Build a codex model with XML]] you defined an object model and stored a new digital object in your repository. We saved the objects and saw that their metadata was indexed in Solr.  Now we will make your repository objects appear in your Blacklight searches.

One of the main features that Hydra adds to Blacklight is the ability to control who has access to which information in search results.  That topic gets a little bit complicated.  For the purpose of this Tutorial we want to stay focused on showing you how to set up an app, define models and create objects based on those models, so in order to keep things simple we will make this Hydra Head behave like an open access repository where everyone can see everything.  Once you've completed this tutorial, you can check out [Access Controls with Hydra](https://github.com/projecthydra/hydra-head/wiki/Access-Controls-with-Hydra) to learn how to assert access controls on objects and enforce those access controls in a Hydra Head.

Once you've turned off access controls in step #1, we show you how to tell blacklight which fields you want to use for default searches in the remaining steps.

# Steps

### Step 1: Comment out and change the lines that enforce access controls in Blacklight's CatalogController

If you open ```app/controllers/catalog_controller.rb``` and look at the code near lines 8-12 you should see this:
```ruby
  # These before_filters apply the hydra access controls
  before_filter :enforce_show_permissions, :only=>:show
  # This applies appropriate access controls to all solr queries
  Hydra::SearchBuilder.default_processor_chain += [:add_access_controls_to_solr_params]
```

This code tells blacklight to enforce access controls on the search and result view pages.  For the time being we will turn this off by commenting out the before_filter and changing ``` += ``` to ``` -= ``` in order to remove ``` :add_access_controls_to_solr_params ``` from the default_processor_chain, the code should look like this:

```ruby
  # These before_filters apply the hydra access controls
  #before_filter :enforce_show_permissions, :only=>:show
  # This applies appropriate access controls to all solr queries
  Hydra::SearchBuilder.default_processor_chain -= [:add_access_controls_to_solr_params]
```
Then, save the file.

### Step 2: Run a search in the CatalogController

Visit or reload the page at [[http://localhost:3000/]].  You should see the Blacklight search interface with a search box.  If you just hit enter on the blank search box (effectively asking blacklight to return all objects) you should get a response with the object(s) you've created using the rails console.  **IN ADDITION** If you search for your title or author by typing part of it into your search box and then hitting enter, you'll see any matching results.  This happens because Blacklight configures 'title', 'author', and 'subject' as default search fields out of the box.  

### Step 3: Tell Blacklight which fields to use in Queries

Sometimes, we want to tell Blacklight explicitly which fields to search in.  Let's fix that by setting the default 'qf' solr parameter.  Open `app/controllers/catalog_controller.rb` and set the `default_solr_params` section (around line 18) to this:

```ruby
    config.default_solr_params = { 
      qf: 'title_tesim author_tesim',
      qt: 'search',
      rows: 10 
    }
```

> NOTE: Because we used the same names, 'author' and 'title' for both our book and codex models, blacklight will return results that match either digital object type.  We'll talk about filtering object types in one of the bonus lessons.

### Step 4: Re-run your search

Save the changes to your `catalog_controller.rb` file, and restart your web server from the terminal (Ctrl-C to stop the server and `rails server` to restart it.)  Now, in your browser, search for one of the words in your author or title fields and you should see a list of matching results.

~~**Tip:** When you make changes like this, you *don't* need to restart the Rails server.  This is because in development mode (which is the default environment for the Rails server), the Rails server reloads any files in app/models, app/controllers, app/views, etc. for every request it receives from a browser.  This makes the server slower, but it makes life much smoother when you're actively developing and making changes.~~

### Step 5: Commit your changes

Now that we've updated our search functionality, it's a great time to commit to git:

```text
git add .
git commit -m "Disabled access controls and set default search fields"
```

# Next Step
Go on to **BONUS** [[Lesson - Define Relationships Between Objects]] or 
explore other [Dive into Hydra](Dive into Hydra#bonus) tutorial bonus lessons.