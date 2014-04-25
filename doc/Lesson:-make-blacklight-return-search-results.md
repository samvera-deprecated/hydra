This lesson is known to work with hydra version 6.1.0, 6.2.0.   
_Please update this wiki to reflect any other versions that have been tested._

# Goals
* Tell Blacklight which fields to use in searches
* Run a search in Blacklight and see results rendered

# Explanation

In [[Lesson: Build a Book Model]] you made a Book object, saved it, and saw that the Book's metadata was indexed in Solr.  Now we will make that Book appear in your Blacklight searches.

# Steps

### Step 1: Run a search in the CatalogController

Visit or reload the page at [[http://localhost:3000/]].  You should see the Blacklight search interface with a search box.  If you search for 'Anna' you don't see any results even though we created a Book called "Anna Karenina" and indexed it in Solr in the last lesson.  

### Step 2: Tell Blacklight which fields to use in Queries

The reason why we're not getting any hits is because we haven't told Blacklight which fields to search in.  Let's fix that by setting the default 'qf' solr parameter.  Open `app/controllers/catalog_controller.rb` and set the `default_solr_params` section (around line 18) to this:

```ruby
    config.default_solr_params = { 
      :qf => 'title_tesim author_tesim',
      :qt => 'search',
      :rows => 10 
    }
```

### Step 3: Re-run your search

Save the file, and refresh your web browser. You should now see a result for "Anna Karenina" when you search for "Anna"

**Tip:** When you make changes like this, you *don't* need to restart the Rails server.  This is because in development mode (which is the default environment for the Rails server), the Rails server reloads any files in app/models, app/controllers, app/views, etc. for every request it receives from a browser.  This makes the server slower, but it makes life much smoother when you're actively developing and making changes.

### Step 4: Commit your changes

Now that we've updated our search functionality, it's a great time to commit to git:

```bash
$> git add .
$> git commit -m "Disabled access controls and set default search fields"
```

# Next Step
Go on to [[Lesson: Define Relationships Between Objects]] or 
explore other [Dive into Hydra](Dive into Hydra#Bonus) tutorial bonus lessons.