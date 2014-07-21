# Goals
* Define a simple OM (Opinionated Metadata) Terminology for Book Metadata that we will track as XML Datastreams
* Start the Rails console and run code interactively in the console
* Create Datastream objects that use your OM Terminology
* Define an ActiveFedora Model for Book objects 
* Declare a Datastream called descMetadata on your Book model and make it use your Book Metadata Terminology
* Delegate methods from Book objects to their descMetadata Datastream
* Create Book objects that use your Book Model
* See how an object has been indexed into Solr
* See how & where objects and metadata are stored in Fedora
* Use OM to Manage how your Metadata is indexed in Solr
* Re-index objects into Solr (update Solr based on any changes to an object, its Model, or the OM Terminologies it uses)

# Explanation
In Fedora an object can have many 'datastreams' which are either content for the object or metadata about the object. We are going to create a 'book' object.  This object will have a metadata datastream which will contain some XML that describes the properties of the book.  We'll call this datastream 'descMetadata'.  You are free to call it whatever you like, but 'descMetadata' is a loose convention that stands for 'descriptive metadata'.

Once you've created an object and saved it in Fedora, you also want to be able to search for it in Solr.  ActiveFedora and OM make it easy to get your metadata into Solr and manage if/when/how your metadata is indexed. 

# Steps

### Step 1: Create an OM Terminology for Book Metadata

First we'll create a Ruby class that represents this descriptive metadata.  Make a new directory for our datastreams by typing in 
```bash
$> mkdir app/models/datastreams
```

Now we'll create a file called `app/models/datastreams/book_metadata.rb`

Paste the following code into that file:

```ruby
class BookMetadata < ActiveFedora::OmDatastream

  set_terminology do |t|
    t.root(path: "fields")
    t.title
    t.author
  end

  def self.xml_template
    Nokogiri::XML.parse("<fields/>")
  end

  def prefix
    # set a datastream prefix if you need to namespace terms that might occur in multiple data streams 
    ""
  end

end
```

This class extends from OmDatastream. OM is a gem that allows us to describe the format of an xml file and access properties. We are using OM by calling the `set_terminology` method.  The xml_template method tells OM how to create a new xml document for this class. 

**Tip:** If you want to learn about OM Terminologies and how they work, visit the [Tame your XML with OM](https://github.com/projecthydra/om/wiki/Tame-your-XML-with-OM) Tutorial.

### Step 2: Start the Rails console

Let's take a look at how this class works.  We'll start the rails console by typing 

```bash
$> rails console
```

You should see something like `Loading development environment (Rails 3.2.11)`.  Now you're in a "[REPL](http://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop)", or *interactive ruby console* that has all of your Rails application's code and configuration loaded. 

### Step 3: In the console, create Datastream objects that use your OM Terminology

Let's create a new BookMetadata instance. I've shown the expected output after each command:

```text
d = BookMetadata.new
 => #<BookMetadata @pid="" @dsid="" @controlGroup="X" changed="false" @mimeType="text/xml" > 
d.title = "ZOIA! Memoirs of Zoia Horn, Battler for the People's Right to Know."
 => "ZOIA! Memoirs of Zoia Horn, Battler for the People's Right to Know." 
d.author = "Horn, Zoia"
 => "Horn, Zoia" 
d.to_xml
 => "<fields>\n  <title>ZOIA! Memoirs of Zoia Horn, Battler for the People's Right to Know.</title>\n  <author>Horn, Zoia</author>\n</fields>"
```

Once you're done, exit the console by typing ```exit```


### Step 4: Define a Book Model

Now let's, create a model that uses this datastream.  Create a new file at `app/models/book.rb`. We'll paste in this code:

```ruby
class Book < ActiveFedora::Base
  has_metadata 'descMetadata', type: BookMetadata

  has_attributes :title, datastream: 'descMetadata', multiple: false
  has_attributes :author, datastream: 'descMetadata', multiple: false

end
```

We've defined our Book model to use the BookMetadata for its datastream called 'descMetadata'.  We're telling the model to use the descMetadata as the delegate for the properties 'title' and 'author'.  We are also telling Active Fedora to treat these attributes as single values rather than as multi-valued arrays.

### Step 5: In the console, create Datastream objects that use your OM Terminology

Now we'll open the `rails console` again and see how to work with our book.

```text
b = Book.create(title: 'Anna Karenina', author: 'Tolstoy, Leo')
 => #<Book pid:"changeme:1", title:["Anna Karenina"], author:["Tolstoy, Leo"]> 
```

We've created a new Book object in the repository.  You can see that it has a pid (Fedora Commons persistence identifier) of 'changeme:1'.  Because you set title and author to delegate to the descMetadata datastream, they are stored in that datastream's XML and can be accessed either through the delegated methods on the Book, or by going specifically to the datastream. 


```text
b.descMetadata
 => #<BookMetadata @pid="changeme:1" @dsid="descMetadata" @controlGroup="M" changed="false" @mimeType="text/xml" > 
b.title
 => "Anna Karenina" 
b.author
 => "Tolstoy, Leo"
b.descMetadata.title
 => ["Anna Karenina"] 
b.descMetadata.author
 => ["Tolstoy, Leo"] 
```


### Step 6: See what your Book objects look like in Fedora and Solr

If we go to [[http://localhost:8983/fedora/objects/changeme:1]] we should see what it looks like in fedora.  Note especially that the xml datastream has been ingested [[http://localhost:8983/fedora/objects/changeme:1/datastreams/descMetadata/content]].  The content of that datastream should look like this in your browser:

```xml
<fields>
  <title>Anna Karenina</title>
  <author>Tolstoy, Leo</author>
</fields>
```

Let's also see that this book has been ingested into the Solr search index. [[http://localhost:8983/solr/select?q=changeme:1]].  It should look like the sample below.  Note that, at this point, the title and author have not been stored in solr.  You only get fields like `system_create_dtsi`, `system_modified_dtsi`, `id`, `object_profile_ssm`, and `has_model_ssim`.  In the next step we will modify our BookMetadata datastream to add the book metadata to the solr document.

```xml
<?xml version="1.0"?>
<response>
  <lst name="responseHeader">
    <int name="status">0</int>
    <int name="QTime">3</int>
    <lst name="params">
      <str name="q">changeme:4</str>
    </lst>
  </lst>
  <result name="response" numFound="1" start="0" maxScore="0.05991731">
    <doc>
      <date name="system_create_dtsi">2013-05-06T16:22:39Z</date>
      <date name="system_modified_dtsi">2013-05-06T16:22:39Z</date>
      <arr name="active_fedora_model_ssim">
        <str>Book</str>
      </arr>
      <str name="id">changeme:4</str>
      <arr name="object_profile_ssm">
        <str>{"datastreams":{"RELS-EXT":{"dsLabel":"Fedora Object-to-Object Relationship Metadata","dsVersionID":"RELS-EXT.0","dsCreateDate":"2013-05-06T16:22:40Z","dsState":"A","dsMIME":"application/rdf+xml","dsFormatURI":null,"dsControlGroup":"X","dsSize":277,"dsVersionable":true,"dsInfoType":null,"dsLocation":"changeme:4+RELS-EXT+RELS-EXT.0","dsLocationType":null,"dsChecksumType":"DISABLED","dsChecksum":"none"},"descMetadata":{"dsLabel":null,"dsVersionID":"descMetadata.0","dsCreateDate":"2013-05-06T16:22:41Z","dsState":"A","dsMIME":"text/xml","dsFormatURI":null,"dsControlGroup":"M","dsSize":81,"dsVersionable":true,"dsInfoType":null,"dsLocation":"changeme:4+descMetadata+descMetadata.0","dsLocationType":"INTERNAL_ID","dsChecksumType":"DISABLED","dsChecksum":"none"},"rightsMetadata":{}},"objLabel":null,"objOwnerId":"fedoraAdmin","objModels":["info:fedora/fedora-system:FedoraObject-3.0"],"objCreateDate":"2013-05-06T16:22:39Z","objLastModDate":"2013-05-06T16:22:39Z","objDissIndexViewURL":"http://localhost:8983/fedora/objects/changeme%3A4/methods/fedora-system%3A3/viewMethodIndex","objItemIndexViewURL":"http://localhost:8983/fedora/objects/changeme%3A4/methods/fedora-system%3A3/viewItemIndex","objState":"A"}</str>
      </arr>
      <arr name="has_model_ssim">
        <str>info:fedora/afmodel:Book</str>
      </arr>
      <date name="timestamp">2013-05-06T16:22:58.397Z</date>
      <float name="score">0.05991731</float>
    </doc>
  </result>
  <lst name="facet_counts">
    <lst name="facet_queries"/>
    <lst name="facet_fields">
      <lst name="active_fedora_model_ssi"/>
      <lst name="object_type_si"/>
    </lst>
    <lst name="facet_dates"/>
    <lst name="facet_ranges"/>
  </lst>
</response>
```
### Step 7: See how your Book metadata are indexed into Solr


The to_solr method is what generates the solr document for your objects and their datastreams.  To see the full solr document for the book we created, call

```text
b.to_solr
```

To see just the part of the solr document that comes from the descMetadata datastream (which has our book title and author), call

```text
b.descMetadata.to_solr
 => {} 
```

As you can see, the descMetadata datastream is returning an empty Hash, meaning that it isn't indexing the author and title values.

### Step 8: Change how your Book metadata are indexed into Solr

To make the BookMetadata Terminology index the author and title fields, you need to reopen `app/models/datastreams/book_metadata.rb` and change the terminology section to look like this:

```ruby
  set_terminology do |t|
    t.root(path: "fields")
    t.title(index_as: :stored_searchable)
    t.author(index_as: :stored_searchable)
  end
```

**Note:** Because we have made changes to our Ruby code that we want to use, we need to restart the Rails console so that it will reload all of the code, including our latest changes.

Now, **restart the rails console** and we can load the object we previously created:

```text
b = Book.find('changeme:1')
 => #<Book pid:"changeme:1", title:"Anna Karenina", author:"Tolstoy, Leo">
```

Check and see that to_solr includes the title and author fields.

```text
b.descMetadata.to_solr
 => {"title_tesim"=>["Anna Karenina"], "author_tesim"=>["Tolstoy, Leo"]} 
```
Now when you call `.to_solr` on a BookMetadata datastream it returns a solr document with fields named `title_tesim` and `author_tesim` that contain your title and author values.  Those are the field names that we will add to Blacklight's queries in [[Lesson: Make Blacklight Return Search Results]].


### Step 9: Re-index an object in Solr

Now we'll call the ```update_index``` method, which republishes the Solr document using the changes we've made.

```text
b.update_index
 => {"responseHeader"=>{"status"=>0, "QTime"=>25}} 
```

If you refresh the document result from solr ([[http://localhost:8983/solr/select?q=changeme:1]]) you should see that these fields have been added to the solr_document:

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

Now your object is indexed properly, but it **won't show up in Blacklight's search results** until you've turned off access controls and added the appropriate fields to Blacklight's queries.  We cover those in the next 2 lessons.

### Step 10: Commit your changes

Now that we've got our model working, it's a great time to commit to git:

```text
git add .
git commit -m "Created a book model and a datastream"
```

# Next Step
Go on to [[Lesson: Make Blacklight Return Search Results]] or return to the [[Dive into Hydra]] page.

If you want to learn about OM Terminologies and how they work, visit the [Tame your XML with OM](https://github.com/projecthydra/om/wiki/Tame-your-XML-with-OM) Tutorial.