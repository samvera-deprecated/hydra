# Goals
* Attaching file sub-resources to models
* See where files are stored in Fedora objects and how to retrieve them

# Explanation

So far, we've only added metadata to our objects.  Let's attach a file that has some content to it.  For example, for our Book model, this could be a image of the book's cover, or for the Page model, an image or pdf of the actual page.

In this case, we'll add a file where we can store a pdf of a page.

# Steps

### Step 1: Add a "pageContent" file resource to the Page model

In our Page model `app/models/page.rb`, we'll add the following line before the end of the class definition:

```ruby
contains "pageContent"
```

Now we have a resource called "pageContent" that can hold any kind of file we wish to add to it.  

**NOTE:** The order of the property, relationship, and attachment (contains) statements within the class definition is not significant.  The edited version of  `app/models/page.rb` should look something like the version below, but the _title_, _number_, _belongs-to-book_, and _pageContent_ statements can come in any order.  We've jumbled things up for demonstration purposes - in real life, we'd probably have some convention that made the code easier to read.

```ruby
class Page < ActiveFedora::Base
  contains "pageContent"
  property :text, predicate: ::RDF::URI.new('http://opaquenamespace.org/hydra/pageText'), multiple: false do |index|
    index.as :stored_searchable
  end
  belongs_to :book, predicate: ActiveFedora::RDF::Fcrepo::RelsExt.isPartOf
  property :number, predicate: ::RDF::URI.new('http://opaquenamespace.org/hydra/pageNumber'), multiple: false do |index|
    index.as :stored_searchable
    index.type :integer
  end
end
```

### Step 2: In the console, add a file to a Page object and save it

>*Note:* you can grab a copy of the sample file for this step by running `curl https://raw.githubusercontent.com/mark-dce/camper/master/sample-assets/AK-Page-4.pdf -o AK-Page-4.pdf` from the command line.

To add the file to one of our page objects, open up the console again:

```ruby
 > p = Page.find("test-3")
 => #<Page id: "test-3", number: 1, text: "Happy families are all alike; every unhappy family is unhappy in its own way.", book_id: "test-1"> 
 > p.attached_files.keys
 => [:pageContent] 
```

Now you're ready to add the file.  Choose a file on your computer that you want to add as the "pageContent".  In the lines below we're assuming that you have a file named "AK-Page-4.pdf" in the parent directory where you started the tutorial.  Replace this with the correct local path for the file you want to use.

```ruby
 > p.pageContent.content = File.open("AK-Page-4.pdf")
 => #<File:../AK-Page-4.pdf>
 > p.pageContent.mime_type = "application/pdf"
 => "application/pdf"
 > p.pageContent.original_name = "AK-Page-4.pdf"
 => "AK-Page-4.pdf"  
 > p.save
 => true
 > p.pageContent.uri
 => #<RDF::URI:0x3ff1d58f9bb4 URI:http://127.0.0.1:8984/rest/dev/test-3/pageContent>
```

### Step 3: See where the file was saved in Fedora

Now if you go to [[http://127.0.0.1:8984/rest/dev/test-3]], you'll see the pageContent sub-resource  listed in the "children" section.

Following the links to it will allow us to view or download the file we've added.

### Step 4: Commit your changes

Now that we've added a file, it's a great time to commit to git:

```bash
git add .
git commit -m "Created a content resource"
```

# Next Step
Proceed to **BONUS** [[Lesson - Generate Rails Scaffolding for Creating and Editing Books]] or explore other [Dive into Hydra](Dive into Hydra#bonus) tutorial bonus lessons.