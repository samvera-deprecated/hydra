# Goals
* *(for now)* Turn off access controls for Blacklight-based searches and "show" views 
* Tell Blacklight which fields to use in searches
* Run a search in Blacklight and see results rendered

# Explanation

In [[Lesson: Build a Book Model]] you made a Book object, saved it, and saw that the Book's metadata was indexed in Solr.  Now we will make that Book appear in your Blacklight searches.

One of the main features that Hydra adds to Blacklight is the ability to control who has access to which information in search results.  That topic gets a little bit complicated.  For the purpose of this Tutorial we want to stay focused on showing you how to set up an app, define models and create objects based on those models, so in order to keep things simple we will make this Hydra Head behave like an open access repository where everyone can see everything.  Once you've completed this tutorial, you can check out [Access Controls with Hydra](https://github.com/projecthydra/hydra-head/wiki/Access-Controls-with-Hydra) to learn how to assert access controls on objects and enforce those access controls in a Hydra Head.

Once you've turned off access controls in step #1, we show you how to tell blacklight which fields you want to use for default searches in the remaining steps.

# Steps

### Step 1: Comment out the lines that enforce access controls in Blacklight's CatalogController

If you open ```app/controllers/catalog_controller.rb``` and look at the code near lines 8-12 you should see this:
```ruby
  # These before_filters apply the hydra access controls
  before_filter :enforce_show_permissions, :only=>:show
  # This applies appropriate access controls to all solr queries
  CatalogController.solr_search_params_logic += [:add_access_controls_to_solr_params]
```

This code tells blacklight to enforce access controls on the search and result view pages.  For the time being we will turn this off by commenting out two lines so that it looks like this:

```ruby
  # These before_filters apply the hydra access controls
  #before_filter :enforce_show_permissions, :only=>:show
  # This applies appropriate access controls to all solr queries
  #CatalogController.solr_search_params_logic += [:add_access_controls_to_solr_params]
```
Then, save the file.

### Step 2: Run a search in the CatalogController

Visit or reload the page at [[http://localhost:3000/]].  You should see the Blacklight search interface with a search box.  If you search for 'Anna' you don't see any results even though we created a Book called "Anna Karenina" and indexed it in Solr in the last lesson.  

### Step 3: Tell Blacklight which fields to use in Queries

The reason why we're not getting any hits is because we haven't told Blacklight which fields to search in.  Let's fix that by setting the default 'qf' solr parameter.  Open `app/controllers/catalog_controller.rb` and set the `default_solr_params` section (around line 18) to this:

```ruby
    config.default_solr_params = { 
      :qf => 'title_tesim author_tesim',
      :qt => 'search',
      :rows => 10 
    }
```

### Step 4: Re-run your search

Save the file, and refresh your web browser. You should now see a result for "Anna Karenina" when you search for "Anna"

**Tip:** When you make changes like this, you *don't* need to restart the Rails server.  This is because in development mode (which is the default environment for the Rails server), the Rails server reloads any files in app/models, app/controllers, app/views, etc. for every request it receives from a browser.  This makes the server slower, but it makes life much smoother when you're actively developing and making changes.

### Step 5: Commit your changes

Now that we've updated our search functionality, it's a great time to commit to git:

```bash
$> git add .
$> git commit -m "Disabled access controls and set default search fields"
```

# Next Step
Go on to **BONUS** [[Lesson: Define Relationships Between Objects]] or 
explore other [Dive into Hydra](Dive into Hydra#Bonus) tutorial bonus lessons.