# Goals

- Understand the difference between unique (single-value) and multi-valued metadata fields
- Learn how to make modifications to the views which support CRUD (Create, Read, Update, Delete) on objects in your repo

# Explanation

This lesson walks you through modifying the "Author" field in your book model to make it either single- or multi-valued.  The lesson then walks through the changes necessary to modify views to read, create, and edit your updated metadata model.

# Steps


### Step 1: Set up Rails Scaffolding for creating and editing Books

We will use the Rails scaffold generator to set up the routes, Controller and Views we need in order to CRUD books.  

**Note:** If you are not familiar with the ideas of Controllers, Views and routes, or aren't familiar with the Rails scaffold generator, go through the [Railsbridge Curriculum](http://curriculum.railsbridge.org/curriculum/curriculum) and then come back to this lesson.  You might also want to read the [Getting Started with Rails](http://guides.rubyonrails.org/getting_started.html) guide.

Tell the generator to build scaffolding for the Book model and make it assume books have `title` and `author` attributes like the ones we set up earlier in [Lesson Build a book model with RDF](https://github.com/projecthydra/hydra/wiki/Lesson---Build-a-book-model-with-RDF).
```text
rails generate scaffold Book title:string author:string
```

>NOTE: If you completed the XML based Codex example instead of the RDF based Book example earlier, all you need to do is replace `Book` with `Codex` in the line above.

When it asks you whether to overwrite `app/models/book.rb`, enter `n` and hit enter. 

Rails assumes that you're using an ActiveRecord based model stored in a SQL databases and creates the necessary database migrations to setup a table to store books.  We're using Fedora, not SQL, to persist our book objects, so you don't need this database migration.  You can delete it with the `git clean` command.

```bash
git clean -df db
```
You'll see output something like this:
```text
Removing db/migrate/20130417230046_create_books.rb
```

### Step 2: Run the server & Explore

Run the `rails server` and visit [[http://localhost:3000/books]]

Explore the pages for creating, editing and showing Books.

### Step 3: Commit your work

```text
git add .
git commit -m "Ran Book scaffold generator"
```

### Step 4: Make the Display view show Authors as a multi-valued field

Open `app/models/book.rb` and edit the multiple setting to be 'true':

```ruby
   property :author, predicate: ::RDF::DC.creator, multiple: true
```

>NOTE: you might be editing the file `app/models/codex.rb` if you completed the XML step of the tutorial, just make sure the value for `multiple:` in the author property is set to `true`

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
    <% @book.author.each do |author|%>
      <li><%= author %></li>
    <% end %>
  </ul>
</p>
```

Save the file and refresh the Show view for a book.  Now authors show up as a list of values.  Note that the display of results of a search is **not** affected, only the view which you can reach from [http://localhost:3000/books](http://localhost:3000/books).

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

This handles displaying existing author values, but what about setting the author value in the first place?  If there are no values in the array, no fields are going to be displayed.  As a stop-gap, we can add a conditional clause that displays an empty text_field after the existing authors are displayed.

```erb
  <%= f.label :author, "Authors" %>
  <% @book.author.each do |author| %>
    <div class="field">
      <%= text_field_tag "book[author][]", author %>
    </div>
  <% end %> 
  <div class="field">
    <%= text_field_tag "book[author][]", nil %>
  </div>
```

Update the `book_params` method in `app/controllers/books_controller.rb` from
```ruby
    def book_params
      params.require(:book).permit(:title, :author)
    end
```
to
```ruby
    def book_params
      params.require(:book).permit(:title, :author=>[])
    end
```

Now every time you save the form you'll get one more additional author. However you get this author even if you haven't filled any value in. Let's update the BooksController to not save authors that don't have names.


```ruby
# app/controllers/books_controller.rb

  def update
    @book.attributes = book_params
    @book.author = params[:book][:author].select { |a| a.present? }
    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

```

*Note:* This still doesn't cover the case where you want to _add_ more than one additional Author to a Book.  That goes beyond the scope of this tutorial because it requires javascript (or a multi-page workflow).


### Step 6: Try out multiple authors

Start up the rails console and run the following commands to add a second author to our book.

```ruby
b = Book.find('test-1')
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

In general, you might not want to build all the views to edit your metadata by hand.  The [hydra-editor](https://github.com/projecthydra/hydra-editor) gem is used by many hydra adopters as a way to handle providing metadata editing forms without having to hand-code for each field.  It also provides javascript support for repeating fields like our author field above so you can add multiple values to a single term without having to save each time.

# Next Step
Proceed to additional hydra tutorials including [Tame your RDF Metadata with ActiveFedora](https://github.com/projecthydra/active_fedora/wiki/Tame-your-RDF-Metadata-with-ActiveFedora) [Tame Your XML With OM](https://github.com/projecthydra/om/wiki/Tame-your-XML-with-OM) and [Access Controls with Hydra](https://github.com/projecthydra/hydra-head/wiki/Access-Controls-with-Hydra) or go back to explore other [Dive into Hydra](Dive into Hydra#bonus) tutorial bonus lessons.