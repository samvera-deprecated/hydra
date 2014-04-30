This lesson is known to work with hydra version 6.1.0, 6.2.0.   
_Please update this wiki to reflect any other versions that have been tested._

# Goals
* Add "file-bearing" Datastreams to models and objects
* See where files are stored in Fedora objects and how to retrieve them

# Explanation

So far, we've only added datastreams that bear metadata.  Let's add a datastream that has some content to it.  For example, this could be a content datastream in our book model that is an image of the book's cover, or a datastream added to the page model that is an image or pdf of that actual page.

In this case, we'll add a file datastream where we can store a pdf of a page.

# Steps

### Step 1: Add a "pageContent" file datastream to the Page model

In our Page model ```app/models/page.rb```, we'll add the following line underneath our descMetadata datastream:

```ruby
has_file_datastream "pageContent"
```

Now we have a datastream called "pageContent" that can hold any kind of file we wish to add to it.  

### Step 2: In the console, add a file to a Page object and save it

To add the file to one of our page objects, open up the console again:

```ruby
 > p = Page.find("changeme:2")
 => #<Page pid:"changeme:2", number:[1], text:["Happy families are all alike; every unhappy family is unhappy in its own way."]> 
 > p.datastreams.keys
 => ["DC", "RELS-EXT", "descMetadata", "pageContent"] 
```

Now you're ready to add the file.  Choose a file on your computer that you want to add as the "pageContent".  In the lines below we're pretending that the path to the file is "/Users/adamw/Desktop/page1.pdf".  Replace that with the correct local path for the file you want to use.

```ruby
 > p.pageContent.content = File.open("/Users/adamw/Desktop/page1.pdf")
 => #<File:/Users/adamw/Desktop/page1.pdf> 
 > p.save
 => true
```

### Step 3: See where the file Datastream was saved in Fedora

Now if you go to [[http://localhost:8983/fedora/objects/changeme:2/datastreams]], you'll see the pageContent datastream in Fedora.  Following the links to it will allow us to view or download the file we've added.

### Step 4: Commit your changes

Now that we've added a content datastream, it's a great time to commit to git:

```bash
$> git add .
$> git commit -m "Created a content datastream"
```

# Next Step
Proceed to [[Lesson: Generate Rails Scaffolding for Creating and Editing Books]] or explore other [Dive into Hydra](Dive into Hydra#bonus) tutorial bonus lessons.