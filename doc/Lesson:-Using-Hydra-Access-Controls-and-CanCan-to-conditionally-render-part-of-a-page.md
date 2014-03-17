This Tutorial is known to work with hydra-head version 6.0.0.  
_Please update this wiki to reflect any other versions that have been tested._

# Goals

# Explanation

# Steps

### Step: Use `can?` to conditionally render html on a page

In `app/views/books/show.html.erb` find the code that's displaying the "Edit" and "Back" links at the bottom of the page.
```erb
<%= link_to 'Edit', edit_book_path(@book) %> |
<%= link_to 'Back', books_path %>
```

Use an `if ... end` clause to only show the "Edit" link if the current user has permission to edit the current book.
```erb
<%- if can?(:edit, @book) %>
  <%= link_to 'Edit', edit_book_path(@book) %> |
<%- end %>
<%= link_to 'Back', books_path %>
```

Now go into the `rails console` and give yourself `edit` access to one book but only `read` access for another.  Look at the show views for the two books.  You should see the "Edit" link on the book that you have permission to edit and you should not see the "Edit" link for the book that you do not have permission to edit.

# Next Step
Return to the [[Access Controls with Hydra]] tutorial.
