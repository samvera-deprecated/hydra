# Goals
* Set up Models to represent relationships between different types of objects
* Create and modify relationships between objects

# Explanation
Now that we have created a model for Books, we will create a separate model for Pages and set a relationship between the two models indicating that any Book can have many Pages and Pages know what Book they belong to.

The syntax for declaring relationships between ActiveFedora models is the same syntax used by ActiveRecord.  It's called the ActiveModel syntax.  Underneath the hood, the two libraries implement relationships in very different ways.  ActiveRecord uses relational database techniques like foreign keys and join tables while ActiveFedora puts this information into RDF relationships in the RELS-EXT datastreams of your Fedora objects. In both cases you can use the ActiveRecord methods to handle relationships.

# Steps

### Step 1: Create an OM Terminology for Page metadata

Next we're going to add a Page model.  We'll start by creating another simple metadata datastream.  This time open ```app/models/datastreams/page_metadata.rb``` and add this content:
```ruby
class Datastreams::PageMetadata < ActiveFedora::OmDatastream
 
  set_terminology do |t|
    t.root(path: "fields")
    t.number index_as: :stored_searchable, type: :integer
    t.text index_as: :stored_searchable
 
  end
 
  def self.xml_template
    Nokogiri::XML.parse("<fields/>")
  end

  def prefix
    '' # add a prefix for solr index terms if you need to namespace identical terms in multiple data streams 
  end

end

```

### Step 2: Create a Page model and make Pages aware of which Book they belong to

Then we'll build a Page model that uses the datastream. Open ```app/models/page.rb``` and paste this in:

```ruby
class Page < ActiveFedora::Base
  has_metadata 'descMetadata', type: Datastreams::PageMetadata
 
  belongs_to :book, :property=> :is_part_of
 
  has_attributes :number, datastream: 'descMetadata', multiple: false
  has_attributes :text, datastream: 'descMetadata', multiple: false

end
```

This is very similar to how our Book class looks, with the exception of the line ```belongs_to :book```.  This establishes a relationship between the book and page model nearly the same as you would do with ActiveRecord.  In ActiveFedora, we have to add the :property attribute as well.  Relationships are stored as RDF within the RELS-EXT datastream.  The :property is actually an RDF predicate. 

### Step 3: Make Books aware of their Pages

Let's edit the Book class in ```app/models/book.rb``` and add the other half of the relationship:

```ruby
  # within app/models/book.rb
  has_many :pages, :property=> :is_part_of
```

### Step 4: In the Console, manipulate relationships between Book and Page objects

Save your changes and then reopen the rails console. Now we ought to be able to create some associations.

```ruby
b = Book.find("changeme:1")
 => #<Book pid:"changeme:1", title:"Anna Karenina", author:"Tolstoy, Leo"> 
p = Page.new(number: 1, text: "Happy families are all alike; every unhappy family is unhappy in its own way.")
 => #<Page pid:"", number:1, text:"Happy families are all alike; every unhappy family is unhappy in its own way."> 
p.book = b
 => #<Book pid:"changeme:1", title:"Anna Karenina", author:"Tolstoy, Leo"> 
p.save
 => true 
b.reload
 => #<Book pid:"changeme:1", title:"Anna Karenina", author:"Tolstoy, Leo"> 
b.pages
 => [#<Page pid:"changeme:2", number:1, text:"Happy families are all alike; every unhappy family is unhappy in its own way.">] 
```

### Step 5: Look at the RDF (if you want to)

**Note:** If you don't know what RDF is and don't care to know, you can skip this step.

Let's look at the RDF that active-fedora uses to represent these relationships.  This metadata is written into the RELS-EXT datastream of your objects.  To see that content, either output it on the command line like this:

```ruby
puts p.datastreams["RELS-EXT"].to_rels_ext
```
Alternatively, look at the datastream in your browser at [http://localhost:8983/fedora/objects/changeme:2/datastreams/RELS-EXT/content](http://localhost:8983/fedora/objects/changeme:2/datastreams/RELS-EXT/content)  (You might need to change the pid in the URL if your page's pid isn't changeme:2)

Either way, you should see RDF that looks like this:

```text
<?xml version="1.0" encoding="UTF-8"?>
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:ns0="info:fedora/fedora-system:def/model#" xmlns:ns1="info:fedora/fedora-system:def/relations-external#">
  <rdf:Description rdf:about="info:fedora/changeme:2">
    <ns0:hasModel rdf:resource="info:fedora/afmodel:Page"/>
    <ns1:isPartOf rdf:resource="info:fedora/changeme:1"/>
  </rdf:Description>
</rdf:RDF>
```

As you can see, it is creating rdf assertions of `info:fedora/fedora-system:def/relations-external#isPartOf` `info:fedora/changeme:1` and `info:fedora/fedora-system:def/model#hasModel` `info:fedora/afmodel:Page`.  

The model assertion is created automatically based on the name of your ActiveFedora model (in this case, Page), but how did ActiveFedora know to use the predicate `info:fedora/fedora-system:def/relations-external#isPartOf` when your `belongs_to` specified a property called :is_part_of?

In other words, how did we get from 

```ruby
belongs_to :book, :property=> :is_part_of
```

to ``info:fedora/fedora-system:def/relations-external#isPartOf`?

The answer is that active-fedora has a config file that it uses to look up RDF predicates based on the property name you specify in your model.  By default, these predicates are read from the active-fedora gem, but you can override them by creating your own copy in config/predicate_mappings.yml in your own application.  To see the default mappings, look at active-fedora's default [predicate mappings YAML file] (https://github.com/projecthydra/active_fedora/blob/master/config/predicate_mappings.yml) on github.

### Step 6: Commit your changes

Now that we've added page relationships, it's a great time to commit to git:

```bash
$> git add .
$> git commit -m "Created a book page model with relationship to the book model"
```

# Next Step
Go on to **BONUS** [[Lesson: Adding Content Datastreams]] or 
explore other [Dive into Hydra](Dive into Hydra#Bonus) tutorial bonus lessons.