# Goals
* Start the Rails console and run code interactively in the console
* Define an ActiveFedora model class for Book objects 
* Create Book objects that use your Book model class
* See how an object has been indexed into Solr
* See how and where objects and metadata are stored in Fedora
* Set indexers to manage how your metadata is indexed into Solr
* Re-index objects into Solr (update the Solr index based on any changes to an object)

# Explanation
We are going to create a 'Book' object.  This object will have a set of RDF statements which will describe the properties of the book.

Once you've created an object and saved it in Fedora, you also want to be able to search for it in Solr.  ActiveFedora makes it easy to get your metadata into Solr and manage if/when/how your metadata is indexed. 

# Steps

### Step 1: Create a Book model
Create a new file at `app/models/book.rb`. We'll paste in this code:

```ruby
class Book < ActiveFedora::Base
  property :title, predicate: ::RDF::Vocab::DC.title, multiple: false
  property :author, predicate: ::RDF::Vocab::DC.creator, multiple: false
end
```

This class extends from ActiveFedora::Base the abstract class which all ActiveFedora models should descend.  The code says, create one property called title, which will be expressed in RDF using the Dublin Core RDF title predicate.  Since multiple is set to false, there may only be one title on each Book.   Author is similar, except it uses the Dublin Core RDF 'creator' predicate.

### Step 2: Start the Rails console

Let's take a look at how this class works.  We'll start the rails console by typing 

```bash
rails console
```

(Or you can abbreviate this as ```rails c```.)

You should see something like `Loading development environment (Rails 4.2.0)`.  Now you're in a "[REPL](http://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop)", or *interactive ruby console* that has all of your Rails application's code and configuration loaded. 

### Step 3: In the console, create a Book object

Let's create a new Book instance. I've shown the expected output after each command:

```text
b = Book.new(id: 'test-1')
ActiveFedora: loading fedora config from /Users/justin/workspace/hydra-demo/config/fedora.yml
ActiveFedora: loading solr config from /Users/justin/workspace/hydra-demo/config/solr.yml
Attempted to init base path `dev`, but it already exists
=> #<Book id: "test-1", title: nil, author: nil>
b.title = "Anna Karenina"
=> "Anna Karenina"
b.author = "Tolstoy, Leo"
=> "Tolstoy, Leo"
b.save
=> true
puts b.resource.dump(:ttl)

<http://127.0.0.1:8984/rest/dev/test-1> a <http://www.w3.org/ns/ldp#RDFSource>,
     <http://www.w3.org/ns/ldp#Container>,
     <http://www.jcp.org/jcr/nt/1.0folder>,
     <http://www.jcp.org/jcr/nt/1.0hierarchyNode>,
     <http://www.jcp.org/jcr/nt/1.0base>,
     <http://www.jcp.org/jcr/mix/1.0created>,
     <http://fedora.info/definitions/v4/repository#Container>,
     <http://fedora.info/definitions/v4/repository#Resource>,
     <http://www.jcp.org/jcr/mix/1.0lastModified>,
     <http://www.jcp.org/jcr/mix/1.0referenceable>;
   <http://purl.org/dc/terms/title> "Anna Karenina";
   <http://fedora.info/definitions/v4/repository#created> "2015-02-04T20:51:20.337Z"^^<http://www.w3.org/2001/XMLSchema#dateTime>;
   <http://fedora.info/definitions/v4/repository#createdBy> "bypassAdmin";
   <http://fedora.info/definitions/v4/repository#exportsAs> <http://127.0.0.1:8984/rest/dev/test-1/fcr:export?format=jcr/xml>;
   <http://fedora.info/definitions/v4/repository#hasParent> <http://127.0.0.1:8984/rest/dev>;
   <http://fedora.info/definitions/v4/repository#lastModified> "2015-02-04T20:51:20.337Z"^^<http://www.w3.org/2001/XMLSchema#dateTime>;
   <http://fedora.info/definitions/v4/repository#lastModifiedBy> "bypassAdmin";
   <http://fedora.info/definitions/v4/repository#mixinTypes> "fedora:Container",
     "fedora:Resource";
   <http://fedora.info/definitions/v4/repository#primaryType> "nt:folder";
   <http://fedora.info/definitions/v4/repository#uuid> "3ed7ee9d-68c7-4b8e-b703-d8a547842aa3";
   <http://fedora.info/definitions/v4/repository#writable> true;
   <http://purl.org/dc/terms/creator> "Tolstoy, Leo";
   <info:fedora/fedora-system:def/model#hasModel> "Book" .
=> nil
```

We've created a new Book object in the repository.  You can see that it has a URI (Fedora Commons persistence identifier) of 'http://127.0.0.1:8984/rest/dev/test-1' (default username/password  `fedoraAdmin/fedoraAdmin`).  Because you set title and author you can see they are also stored in the RDF graph.  We can use those values by calling their accessors.

```text
b.author
 => "Tolstoy, Leo"
b.title
 => "Anna Karenina"
```

Finally we'll get the Fedora URI and the abbreviated version (`id`) of the object:

```text
b.uri
=> "http://127.0.0.1:8984/rest/dev/test-1"
b.id
=> "test-1"
```
>
**Note:**
In the last command of the sequence, we printed the RDF graph for the Book object using Turtle (:ttl) syntax `b.resource.dump(:ttl)`. You can also print the graph using other RDF serialization formats such as N-Triples and JSON-LD
* `b.resource.dump(:ntriples)`
* `b.resource.dump(:jsonld)`
>

### Step 4: See what your Book objects look like in Fedora and Solr

If we go to the URI of your object in a browser; i.e. [http://127.0.0.1:8984/rest/dev/test-1](http://127.0.0.1:8984/rest/dev/test-1), we should see what it looks like in Fedora.  In the properties section you should see the attributes we set:

![screen shot 2015-02-04 at 3 00 07 pm](https://cloud.githubusercontent.com/assets/92044/6049601/9962014c-ac7e-11e4-873e-2c01014ee699.png)

Let's also see that this book has been ingested into the Solr search index. If you followed the example and used test-1 for your book's ID, the solr page will be [[http://localhost:8983/solr/hydra-development/select?q=test-1]] - the generic pattern looks like this: [[http://localhost:8983/solr/hydra-development/select?q=XXX]] and replace the `XXX` with the `id` from your console session. The page should look like the sample below.  Note that, at this point, the title and author have not been indexed in solr.  You only get fields like `system_create_dtsi`, `system_modified_dtsi`, `id`, `object_profile_ssm`, and `has_model_ssim`.  In the next step we will modify our Book model to add the book metadata to the solr document.

```xml
<?xml version="1.0"?>
<response>
  <lst name="responseHeader">
    <int name="status">0</int>
    <int name="QTime">27</int>
    <lst name="params">
      <str name="q">test-1</str>
    </lst>
  </lst>
  <result name="response" numFound="1" start="0" maxScore="0.0010456265">
    <doc>
      <date name="system_create_dtsi">2015-02-04T20:51:20Z</date>
      <date name="system_modified_dtsi">2015-02-04T20:59:59Z</date>
      <str name="active_fedora_model_ssi">Book</str>
      <arr name="has_model_ssim">
        <str>Book</str>
      </arr>
      <str name="id">test-1</str>
      <arr name="object_profile_ssm">
        <str>
          {"id":"test-1","title":"Anna Karenina","author":"Tolstoy, Leo"}
        </str>
      </arr>
      <long name="_version_">1492211308347523072</long>
      <date name="timestamp">2015-02-04T20:59:59.422Z</date>
      <float name="score">0.0010456265</float>
    </doc>
  </result>
  <lst name="facet_counts">
    <lst name="facet_queries"/>
    <lst name="facet_fields">
      <lst name="active_fedora_model_ssi">
        <int name="Book">1</int>
      </lst>
      <lst name="object_type_si"/>
    </lst>
    <lst name="facet_dates"/>
    <lst name="facet_ranges"/>
    <lst name="facet_intervals"/>
  </lst>
  <lst name="spellcheck">
    <lst name="suggestions">
      <bool name="correctlySpelled">true</bool>
    </lst>
  </lst>
</response>
```

### Step 5: See how your Book metadata are indexed into Solr

The to_solr method is what generates the solr document for your objects.  To see the full solr document for the book we created, call

```text
b.to_solr
=> {"system_create_dtsi"=>"2015-02-04T20:51:20Z", "system_modified_dtsi"=>"2015-02-04T20:59:59Z", "active_fedora_model_ssi"=>"Book", "has_model_ssim"=>["Book"], :id=>"test-1", "object_profile_ssm"=>"{\"id\":\"test-1\",\"title\":\"Anna Karenina\",\"author\":\"Tolstoy, Leo\"}"}
```

As you can see, the the author and title values are not indexed (excluding `object_profile_ssm`).

Once you're done, exit the console by typing ```exit```

### Step 6: Change how your Book metadata are indexed into Solr

To make the Book model index the author and title fields, you need to reopen `app/models/book.rb` and change the class to look like this:

```ruby
class Book < ActiveFedora::Base
  property :title, predicate: ::RDF::Vocab::DC.title, multiple: false do |index|
    index.as :stored_searchable
  end
  property :author, predicate: ::RDF::Vocab::DC.creator, multiple: false do |index|
    index.as :stored_searchable
  end
end
```

**Note:** Because we have made changes to our Ruby code that we want to use, we need to restart the Rails console so that it will reload all of the code, including our latest changes.

Now, **restart the rails console** and we can load the object we previously created:

```text
b = Book.find("test-1")
=> #<Book id: "test-1", title: "Anna Karenina", author: "Tolstoy, Leo">
```

Check and see that to_solr includes the title and author fields.

```text
b.to_solr
=> {"system_create_dtsi"=>"2015-02-04T20:51:20Z", "system_modified_dtsi"=>"2015-02-04T20:59:59Z", "active_fedora_model_ssi"=>"Book", "has_model_ssim"=>["Book"], :id=>"test-1", "object_profile_ssm"=>"{\"id\":\"test-1\",\"title\":\"Anna Karenina\",\"author\":\"Tolstoy, Leo\"}", "title_tesim"=>["Anna Karenina"], "author_tesim"=>["Tolstoy, Leo"]}
```

Now when you call `.to_solr` on a Book it returns a solr document with fields named `title_tesim` and `author_tesim` that contain your title and author values.  Those are the field names that we will add to Blacklight's queries in [[Lesson - Make Blacklight Return Search Results]].


### Step 7: Re-index an object in Solr

Now we'll call the ```update_index``` method, which republishes the Solr document using the changes we've made.

```text
b.update_index
 => {"responseHeader"=>{"status"=>0, "QTime"=>25}} 
```

If you refresh the document result from solr ([[http://localhost:8983/solr/hydra-development/select?q=test-1]]) you should see that these fields have been added to the solr_document:

```xml
<arr name="title_tesim">
    <str>Anna Karenina</str>
</arr>
<arr name="author_tesim">
    <str>Tolstoy, Leo</str>
</arr>
```

**Aside:** The strange suffixes on the field names are provided by [solrizer](http://github.com/projecthydra/solrizer). You can read about them in the [solrizer documentaton](https://github.com/projecthydra/hydra-head/wiki/Solr-Schema). In short, the **_tesim** suffix tells Solr to treat the values as _**t**ext_ in the _**e**nglish_ language that should be _**s**tored_, _**i**ndexed_ and allowed to be _**m**ultivalued_. This _tesim suffix is a useful catch-all that gets your searches working predictably with minimal fuss. As you encounter cases where you need to index your content in more nuanced ways, there are ways to change these suffixes in order to achieve different results in Solr.

#### Why doesn't the Book show up in Blacklight?

Now your object is indexed properly, but it **won't show up in Blacklight's search results** until you've turned off access controls and added the appropriate fields to Blacklight's queries.  We cover those in a subsequent lesson, but first we'll take a look at modeling a similar object using XML instead of RDF to store our metadata.

### Step 8: Commit your changes

Now that we've got our model working, it's a great time to commit to git:

```text
git add .
git commit -m "Create a book model using RDF"
```

# Next Step
If you want to learn about modeling similar data in XML, proceed to [[Lesson - Build a codex model with XML]]; otherwise, go on directly to [[Lesson - Make Blacklight Return Search Results]] or return to the [[Dive into Hydra]] page.