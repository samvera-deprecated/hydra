This Tutorial is known to work with hydra-head version 6.0.0.  
_Please update this wiki to reflect any other versions that have been tested._

# Goals

# Explanation

# Steps

### Step 1: Enforce Show permissions on Blacklight search results

When we turned off access controls as part of the [[Dive into Hydra]] tutorial, we commented out two lines.  The first line was turning on gated discovery.  We covered that in the previous lesson.  The other line was telling Blacklight to prevent unauthorized access to `show` views for items from your searches.  Let's enable that filter and see what it does.

Open app/controllers/catalog_controller.rb and find these lines
```ruby
  # These before_filters apply the hydra access controls
  # before_filter :enforce_show_permissions, :only=>:show
```

Uncomment the line with the `before_filter`
```ruby
  # These before_filters apply the hydra access controls
  before_filter :enforce_show_permissions, :only=>:show
```

### Step 2: Test the enforcement of Show permissions on Blacklight search results

In your browser, log into the application as yourself, run a search, and click on the link to a book that you only have `discover` access to.  Depending on what experiments you've done based on the previous lesson, you might have to go into the `rails console` and either create a new book that you have discover access to or modify an existing book to give you discover access.  

You should have been redirected back to the search results page with a message reading _"You do not have sufficient access privileges to read this document, which has been marked private."_

**Note:** For this example, it's important that you to _only_ have discover access (not `read` or `edit`) and that none of the groups you belong to have `read` or `edit` access either.  If you or one of your groups has `read` or `edit` access then you will see the book's `show` page instead of being redirected by the access controls.

In the `rails console`, grant yourself 'read' or 'edit' access to the book and save the book.  Then in the browser you will be able to visit the `show` page for that book instead of being redirected like before.

# Next Step
Go on to [[Lesson: Use Hydra Access Controls and CanCan to decide whether to render a page]] or return to the [[Access Controls with Hydra]] tutorial.
