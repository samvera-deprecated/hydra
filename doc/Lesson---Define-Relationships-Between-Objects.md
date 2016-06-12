# Goals
* Set up Models to represent relationships between different types of objects
* Create and modify relationships between objects

# Explanation
Now that we have created a model for Books, we will create a separate model for Pages and set a relationship between the two models indicating that any Book can have many Pages and Pages know what Book they belong to.

The syntax for declaring relationships between ActiveFedora models is the same syntax used by ActiveRecord.  It's called the ActiveModel syntax.  Underneath the hood, the two libraries implement relationships in very different ways.  ActiveRecord uses relational database techniques like foreign keys and join tables while ActiveFedora puts this information into RDF relationships in the RELS-EXT datastreams of your Fedora objects. In both cases you can use the ActiveRecord methods to handle relationships.

# Steps

### Step 1: Define a Page object model

Next we're going to add a Page model.  We'll start by creating another simple model.  This time open ```app/models/page.rb``` and add this content:

```ruby
class Page < ActiveFedora::Base
  
  property :number, predicate: ::RDF::URI.new('http://opaquenamespace.org/hydra/pageNumber'), multiple: false do |index|
    index.as :stored_searchable
    index.type :integer
  end
  
  property :text, predicate: ::RDF::URI.new('http://opaquenamespace.org/hydra/pageText'), multiple: false do |index|
    index.as :stored_searchable
  end

  belongs_to :book, predicate: ActiveFedora::RDF::Fcrepo::RelsExt.isPartOf

end

```

This is very similar to how our RDF-based Book class looks, we're just adding different attributes defined by different predicates.  I.E. a Book has an _author_ and a _title_, while a Page has a _number_ and _text_.

The final line in the page example establishes a relationship between the page and book models. This works very similarly to the way you would define the relationship with ActiveRecord.  In ActiveFedora, we have to add the :predicate attribute as well that describes the type of relationship. 

If you completed the XML Codex lesson but not the Book lesson, change the next to last line to read `belongs_to :codex, ...` instead of `belongs_to :book, ...`.  It's totally OK to mix models with both XML and RDF in this way! If you defined a Codex object model, but not a Book object model in previous lessons, you can complete the rest of this lesson by substituting `codex` anywhere the lesson says `book` (be sure to match capitalization, etc.).  Hydra, especially Active Fedora, is designed to let you manipulate your digital repository objects as much like standard ruby objects as possible; this means that we try to abstract away the specific mechanisms used to persist metadata.  So, once your objects are defined, the code you write to manipulate object with RDF metadata looks very much like the code you write to manipulate objects with XML metadata.

> ASIDE #1: It's generally best practice to use well-known RDF predicates when defining metadata terms, e.g. using DC.title for your title term. In some cases, however, RDF ontologies don't exist to express the concepts we want to track.  Surprisingly, page numbers are in this group; therefore, we have used a predicate registry created by the community to define our page number predicate: <span>http:/</span>/opaquenamespace.org/hydra/pageNumber.  

> ASIDE #2: We are explicitly assigning a type for the page number index.  This lets us control our indexing and searching to use integer sorting (e.g. 1,2,3,4,...9,10,11) instead of the default lexical sorting use for strings (e.g. '1','10','11','2','21','27','5','6','60').  By default, Hydra and Active Fedora assume all metadata are text values.  You can find additional information on the available indexing options in the [Solrizer ReadME](https://github.com/projecthydra/solrizer) and in the [solrizer code that defines the default indexing strategies](https://github.com/projecthydra/solrizer/blob/master/lib/solrizer/default_descriptors.rb)

### Step 2: Make Books aware of their Pages

Let's edit the Book class in ```app/models/book.rb``` and add the other half of the relationship:

```ruby
  # within app/models/book.rb
  has_many :pages
```

### Step 3: In the Console, manipulate relationships between Book and Page objects

Save your changes and then reopen the rails console. Now we ought to be able to create some associations.

```ruby
b = Book.find("test-1")
 => #<Book id: "test-1", title: "Anna Karenina", author: "Tolstoy, Leo"> 
p = Page.new(id: "test-3", number: 1, text: "Happy families are all alike; every unhappy family is unhappy in its own way.")
 => #<Page id: "test-3", number: 1, text:"Happy families are all alike; every unhappy family is unhappy in its own way."> 
p.book = b
 => #<Book id: "test-1", title: "Anna Karenina", author: "Tolstoy, Leo"> 
p.save
 => true
b.pages
 => [#<Page id: "test-3", number: 1, text: "Happy families are all alike; every unhappy family is unhappy in its own way.", book_id: "test-1">]
```

### Step 4: Look at the RDF (if you want to)

**Note:** If you don't know what RDF is and don't care to know, you can skip this step.

Let's look at the RDF that active-fedora uses to represent these relationships. To see that content, either output it on the command line like this:

```ruby
puts p.resource.dump(:ttl)
```
Alternatively, look at the resource in your browser at [http://127.0.0.1:8984/rest/dev/test-3](http://127.0.0.1:8984/rest/dev/test-3)  (You might need to change the pid in the URL if your page's id isn't test-3)

Either way, you should see RDF that looks like this:

```text
<http://127.0.0.1:8984/rest/dev/test-3> a <http://www.w3.org/ns/ldp#RDFSource>,
     <http://www.w3.org/ns/ldp#Container>,
     <http://www.jcp.org/jcr/nt/1.0folder>,
     <http://www.jcp.org/jcr/nt/1.0hierarchyNode>,
     <http://www.jcp.org/jcr/nt/1.0base>,
     <http://www.jcp.org/jcr/mix/1.0created>,
     <http://fedora.info/definitions/v4/repository#Container>,
     <http://fedora.info/definitions/v4/repository#Resource>,
     <http://www.jcp.org/jcr/mix/1.0lastModified>,
     <http://www.jcp.org/jcr/mix/1.0referenceable>;
   <http://fedora.info/definitions/v4/repository#created> "2015-02-04T23:09:20.012Z"^^<http://www.w3.org/2001/XMLSchema#dateTime>;
   <http://fedora.info/definitions/v4/repository#createdBy> "bypassAdmin";
   <http://fedora.info/definitions/v4/repository#exportsAs> <http://127.0.0.1:8984/rest/dev/test-3/fcr:export?format=jcr/xml>;
   <http://fedora.info/definitions/v4/repository#hasParent> <http://127.0.0.1:8984/rest/dev>;
   <http://fedora.info/definitions/v4/repository#lastModified> "2015-02-04T23:09:20.012Z"^^<http://www.w3.org/2001/XMLSchema#dateTime>;
   <http://fedora.info/definitions/v4/repository#lastModifiedBy> "bypassAdmin";
   <http://fedora.info/definitions/v4/repository#mixinTypes> "fedora:Container",
     "fedora:Resource";
   <http://fedora.info/definitions/v4/repository#primaryType> "nt:folder";
   <http://fedora.info/definitions/v4/repository#uuid> "6c2b0f28-f211-4e91-a1e6-59b86d916ad6";
   <http://fedora.info/definitions/v4/repository#writable> true;
   <http://opaquenamespace.org/hydra/pageNumber> 1;
   <http://opaquenamespace.org/hydra/pageText> "Happy families are all alike; every unhappy family is unhappy in its own way.";
   <info:fedora/fedora-system:def/model#hasModel> "Page";
   <info:fedora/fedora-system:def/relations-external#isPartOf> <http://127.0.0.1:8984/rest/dev/test-1> .
=> nil
```

As you can see, it is creating rdf assertions of `info:fedora/fedora-system:def/relations-external#isPartOf` `http://127.0.0.1:8984/rest/dev/test-1` and `info:fedora/fedora-system:def/model#hasModel` `Page`. The model assertion is created automatically based on the name of your ActiveFedora model (in this case, Page)

### Step 5: Commit your changes

Now that we've added page relationships, it's a great time to commit to git:

```text
git add .
git commit -m "Created a page model with relationship to the book model"
```

# Next Step
Go on to **BONUS** [[Lesson - Adding attached files]] or 
explore other [Dive into Hydra](Dive into Hydra#Bonus) tutorial bonus lessons.
