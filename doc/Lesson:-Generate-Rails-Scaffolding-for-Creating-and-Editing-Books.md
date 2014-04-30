This Tutorial is known to work with hydra version 6.1.0, 6.2.0.  
_Please update this wiki to reflect any other versions that have been tested._

# Goals

- Understand the difference between unique (single-value) and multi-valued metadata fields
- Learn how to make modifications to the views which support CRUD (Create, Read, Update, Delete) on objects in your repo

# Explanation

This lesson walks you through modifying the "Title" field in your book model to make it either single- or multi-valued.  The lesson then walks through the changes necessary to modify views to read, create, and edit your updated metadata model.

# Steps


### Step 1: Set up Rails Scaffolding for creating and editing Books

We will use the Rails scaffold generator to set up the routes, Controller and Views we need in order to CRUD books.  

**Note:** If you are not familiar with the ideas of Controllers, Views and routes, or aren't familiar with the Rails scaffold generator, go through the [Railsbridge Curriculum](http://curriculum.railsbridge.org/curriculum/curriculum) and then come back to this lesson.  You might also want to read the [Getting Started with Rails](http://guides.rubyonrails.org/getting_started.html) guide.

Tell the generator to build scaffolding for the Book model and make it assume books have `title` and `author` attributes like the ones we set up earlier in [[Lesson: build a book model]].
```text
rails generate scaffold Book title:string author:string
```

When it asks you whether to overwrite `app/models/book.rb`, enter `n` and hit enter. 

Depending on the specific version of rails you are running the generator creates a few things that we don't want in the `test` and `db` directories.  Delete them with the `git clean` command.

```bash
$ git clean -df test db
```
You'll see output something like this:
```text
Removing db/migrate/20130417230046_create_books.rb
Removing test/fixtures/books.yml
Removing test/functional/books_controller_test.rb
Removing test/unit/book_test.rb
Removing test/unit/helpers/
```

### Step 2: Run the server & Explore

Run the `rails server` and visit [[http://localhost:3000/books]]

If you see 'uninitialized constant Book::BookMetadata' you'll need to edit `app/models/datastreams/book_metadata.rb`

Replace the first line BookMetadata with Datastreams::BookMetadata:

```ruby
class Datastreams::BookMetadata < ActiveFedora::OmDatastream
```

You will also need to edit `app/models/book.rb`

Again, replace BookMetadata with Datastreams::BookMetadata:

```ruby
  has_metadata 'descMetadata', type: Datastreams::BookMetadata
```
Explore the pages for creating, editing and showing Books.  

### Step 3: Commit your work

```text
git add .
git commit -m "Ran scaffold generator"
```

### Step 4: Make the Display view show Authors as a multi-valued field

Open `app/models/book.rb` and edit the multiple setting to be 'true':

```ruby
   has_attributes :author, datastream: 'descMetadata', multiple: true
```

Now you need to tell your hydra application how to display multivalued fields in the 'show' (Display) view for this model. 
In `app/views/books/show.html.erb` find the lines that display the author field.
```erb
  <p>
    <b>Author:</b>
    <%= @book.author %>
  </p>
```

We want to make these lines iterate over the values returned by `@book.author` and put them in a list
```erb
<p>
  <b>Author(s):</b>
  <ul>
    <%- @book.author.each do |author|%>
      <li><%= author %></li>
    <%- end %>
  </ul>
</p>
```

Save the file and refresh the Show view for a book.  Now authors show up as a list of values.

### Step 5: Allow Create and Update views to display Authors as a multi-valued field

The `_form` partial defines the guts of the form that's used in both the `new` (Create) view and the `edit` (Update) view.  That makes our lives simpler because we only have to update that one file to fix both pages!

In `app/views/books/_form.html.erb` find the lines that display the author field.

```erb
<div class="field">
    <%= f.label :author %><br />
    <%= f.text_field :author %>
</div>
```

Replace those lines with something that iterates over the values from `@book.author` and displays a text_field tag for each of them.  Note that the @name attribute will be set to "book[author][]".  The trailing `[]` in the name tells Rails that this is a multivalued field that should be parsed as an Array.
```erb
  <%= f.label :author, "Authors" %>
  <% @book.author.each do |author| %>
    <div class="field">
      <%= text_field_tag "book[author][]", author %>
    </div>
  <% end %> 
```

This handles displaying existing author values, but what about setting the author value in the first place?  If there are no values in the array, no fields are going to be displayed.  As a stop-gap, we can add a conditional clause that displays an empty text_field when the array is empty.

```erb
  <%= f.label :author, "Authors" %>
  <% @book.author.each do |author| %>
    <div class="field">
      <%= text_field_tag "book[author][]", author %>
    </div>
  <% end %> 
  <%- if @book.author.empty? %>
    <div class="field">
      <%= text_field_tag "book[author][]", nil %>
    </div>
  <%- end %>
```

*Note:* This still doesn't cover the case where you want to _add_ more than one Author to a Book.  That goes beyond the scope of this tutorial because it requires javascript (or a multi-page workflow).

> #### Rails 4-only step
>
> Update the `book_params` method in `app/controllers/books_controller.rb` from
> ```ruby
>     def book_params
>       params.require(:book).permit(:title, :author)
>     end
> ```
> to
> ```ruby
>     def book_params
>       params.require(:book).permit(:title, :author=>[])
>     end
> ```

### Step 6: Try out multiple authors

Start up the rails console and run the following commands to add a second author to our book.

```ruby
b = Book.find('changeme:1')
b.author += ['Some other author']
b.save
```

Visit [[http://localhost:3000/books]] again and see that multiple authors show up and that you can edit them.

### Step 7: Commit your Work

```text
git add .
git commit -m "Handling multivalued author fields"
```

### Step 8: [Optional] Enhance the display of Title fields

Based on the concepts in steps 1-7, determine whether you want 'Title' to display as a single or multi-valued field and make appropriate edits to the 'show' view and '_form' partial on your own.

# Next Step
Proceed to [[Lesson: Set up your Rails Application to use RSpec]] or explore other [Dive into Hydra](Dive into Hydra#Bonus) tutorial bonus lessons.