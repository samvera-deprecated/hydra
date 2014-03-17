This lesson is known to work with hydra version 6.1.0.   
_Please update this wiki to reflect any other versions that have been tested._

# Goals
* *(for now)* Turn off access controls for Blacklight-based searches and "show" views 

# Explanation
One of the main features that Hydra adds to Blacklight is the ability to control who has access to which information in search results.  That topic gets a little bit complicated.  For the purpose of this Tutorial we want to stay focused on showing you how to set up an app, define models and create objects based on those models, so in order to keep things simple we will make this Hydra Head behave like an open access repository where everyone can see everything.  Once you've completed this tutorial, you can check out [Access Controls with Hydra](https://github.com/projecthydra/hydra-head/wiki/Access-Controls-with-Hydra) to learn how to assert access controls on objects and enforce those access controls in a Hydra Head.

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

### Step 2: Save the file

Then, save the file.


# Next Step
Go on to [[Lesson: Make Blacklight Return Search Results]] or return to the [[Dive into Hydra]] page.