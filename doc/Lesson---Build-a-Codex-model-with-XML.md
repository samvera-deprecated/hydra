# Goals
* Define a simple OM (Opinionated Metadata) Terminology for Codex Metadata that will be saved as an XML file attachment to our object (formerly known as a Datastream)
* Start the Rails console and run code interactively in the console
* Create Datastream objects that use your OM Terminology
* Define an ActiveFedora Model for Codex objects 
* Declare a Datastream called descMetadata on your Codex model and make it use your Codex Metadata Terminology
* Delegate methods from Codex objects to their descMetadata Datastream
* Create Codex objects that use your Codex Model
* See how an object has been indexed into Solr
* See how & where objects and metadata are stored in Fedora
* Define how your Metadata is indexed in Solr
* Re-index objects into Solr (update Solr based on any changes to an object or its Model)

# Explanation
In Fedora 4 an object can have many attachments.  Fedora 4 attachments work very similarly to Fedora 3 datastreams, but are generalized to support any type of binary attachment. In this lesson, we are going to create a 'codex' object.  This object will have metadata stored as an XML attachment that describes the properties of the codex.  We'll call this attachment 'descMetadata'.  You are free to call it whatever you like, but 'descMetadata' is a loose convention that stands for 'descriptive metadata'.

Once you've created an object and saved it in Fedora, you also want to be able to search for it in Solr.  ActiveFedora and OM make it easy to get your metadata into Solr and manage if/when/how your metadata is indexed. 

# Steps

### Step 1: Create an OM Terminology for Codex Metadata

First we'll create a Ruby class that represents this descriptive metadata.  Make a new directory for our datastreams by typing in 
```bash
$> mkdir app/models/datastreams
```

Now we'll create a file called `app/models/datastreams/codex_metadata.rb`

Paste the following code into that file:

```ruby
class CodexMetadata < ActiveFedora::OmDatastream

  set_terminology do |t|
    t.root(path: "fields")
    t.title
    t.author
  end

  def self.xml_template
    Nokogiri::XML.parse("<fields/>")
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

(Or you can abbreviate this as ```rails c```.)

You should see something like `Loading development environment (Rails 4.2.0)`.  Now you're in a "[REPL](http://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop)", or *interactive ruby console* that has all of your Rails application's code and configuration loaded. 

### Step 3: In the console, create Datastream objects that use your OM Terminology

Let's create a new CodexMetadata instance. I've shown the expected output after each command:

```text
d = CodexMetadata.new
 => #<CodexMetadata uri="" >
d.title = "ZOIA! Memoirs of Zoia Horn, Battler for the People's Right to Know."
 => "ZOIA! Memoirs of Zoia Horn, Battler for the People's Right to Know." 
d.author = "Horn, Zoia"
 => "Horn, Zoia" 
puts d.to_xml
<?xml version="1.0"?>
<fields>
  <title>ZOIA! Memoirs of Zoia Horn, Battler for the People's Right to Know.</title>
  <author>Horn, Zoia</author>
</fields>
 => nil 
```

Once you're done, exit the console by typing ```exit```


### Step 4: Define a Codex Object Model

Now let's create a model that uses this datastream.  Create a new file at `app/models/codex.rb`. We'll paste in this code:

```ruby
class Codex < ActiveFedora::Base
  contains 'descMetadata', class_name: 'CodexMetadata'

  property :title, delegate_to: 'descMetadata', multiple: false
  property :author, delegate_to: 'descMetadata', multiple: false

end
```

We've instructed our Codex model to use the CodexMetadata class to interpret XML metadata stored in a file attachment called 'descMetadata'.  We're telling the model to use the descMetadata as the delegate for the properties 'title' and 'author'.  We are also telling Active Fedora to treat these attributes as single values rather than as multi-valued arrays.

### Step 5: In the console, add metadata terms to your object using your OM Terminology.

Now we'll open the `rails console` again and see how to work with our codex.

```text
c = Codex.create(id: 'test-2', title: 'On the Equilibrium of Planes', author: 'Archimedes of Syracuse')
 => #<Codex id: "test-2", title: "On the Equilibrium of Planes", author: "Archimedes of Syracuse"> 
```

We've created a new Codex object in the repository. Because you set title and author to delegate to the descMetadata datastream, they are stored in that datastream's XML and can be accessed either through the delegated methods on the Book, or by going specifically to the datastream. 


```text
c.descMetadata
 => #<CodexMetadata uri="http://127.0.0.1:8984/rest/dev/test-1/descMetadata" > 
c.title
 => "On the Equilibrium of Planes" 
c.author
 => "Archimedes of Syracuse"
c.descMetadata.title
 => ["On the Equilibrium of Planes"] 
c.descMetadata.author
 => ["Archimedes of Syracuse"] 
```

Note, because we used the `.create` method the new object was automatically saved to fedora.  In general, you either need to use the `.new` method followed at some point by the `.save` OR the `.create` method to both build and save a new object.  Any time you make changes to an object, you need to call `.save` on the object to make your changes persistent.  

### Step 6: See what your Codex objects look like in Fedora and Solr

If we go to [[http://localhost:8984/rest/dev/test-2]] we should see what it looks like in fedora.  If you followed the example and used test-2 for your codex's ID, the solr page will be [[http://localhost:8983/solr/hydra-development/select?q=test-2]] - the generic pattern looks like this: http://localhost:8983/solr/hydra-development/select?q=XXX and replace the XXX with the id from your console session. The page should look like the sample below. Note that, at this point, the `title` and `author` have not been indexed in solr. You only get fields like `system_create_dtsi`, `system_modified_dtsi`, `id`, `object_profile_ssm`, and `has_model_ssim`. In the next step we will modify our codex model to add the codex metadata to the solr document.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<response>
  <lst name="responseHeader">
    <int name="status">0</int>
    <int name="QTime">2</int>
    <lst name="params">
      <str name="q">test-2</str>
    </lst>
  </lst>
  <result name="response" numFound="1" start="0" maxScore="0.029457245">
    <doc>
      <date name="system_create_dtsi">2015-03-28T03:11:45Z</date>
      <date name="system_modified_dtsi">2015-03-28T03:11:45Z</date>
      <str name="active_fedora_model_ssi">Codex</str>
      <arr name="has_model_ssim">
        <str>Codex</str>
      </arr>
      <str name="id">test-2</str>
      <arr name="object_profile_ssm">
        <str>{"id":"test-2","title":"On the Equilibrium of Planes","author":"Archimedes of Syracuse"}</str>
      </arr>
      <long name="_version_">1496855143638892544</long>
      <date name="timestamp">2015-03-28T03:11:45.868Z</date>
      <float name="score">0.029457245</float>
    </doc>
  </result>
  <lst name="facet_counts">
    <lst name="facet_queries"/>
    <lst name="facet_fields">
      <lst name="active_fedora_model_ssi">
        <int name="Codex">1</int>
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

If you completed the RDF modeling lesson, you can see that other than the object model name, the Solr output looks identical regardless of whether we use XML or RDF to store our metadata.  In the next step we will modify our CodexMetadata datastream to add the codex metadata to the solr document.

### Step 7: See how your Codex metadata are indexed into Solr


The to_solr method is what generates the solr document for your objects and their datastreams. The solr document represents the terms that will be indexed in solr for each object. To see the full solr document for the codex we created, call

```text
c.to_solr
 => {"system_create_dtsi"=>"2015-03-28T03:11:45Z", "system_modified_dtsi"=>"2015-03-28T03:11:45Z", "active_fedora_model_ssi"=>"Codex", "has_model_ssim"=>["Codex"], :id=>"test-2", "object_profile_ssm"=>"{\"id\":\"test-2\",\"title\":\"On the Equilibrium of Planes\",\"author\":\"Archimedes of Syracuse\"}"} 
```

As you can see, the author and title values are included in the object profile, but they aren't being indexed as individual terms.

### Step 8: Change how your Codex metadata are indexed into Solr

To make your codex object the author and title fields, you need to reopen `app/models/codex.rb` and specify which terms you would like indexed and how:

```ruby
class Codex < ActiveFedora::Base
  contains 'descMetadata', class_name: 'CodexMetadata'

  property :title, delegate_to: 'descMetadata', multiple: false  do |index|
    index.as :stored_searchable
  end
  property :author, delegate_to: 'descMetadata', multiple: false do |index|
    index.as :stored_searchable
  end

end
```

**Note:** Because we have made changes to our Ruby code that we want to use, we need to reload all of the code, including our latest changes.  There are two methods to do this:
* Exit and restart the rails console: `exit` the rails console followed by `rails c` from the shell prompt
* Reload the application code by calling `reload!` from within the rails console itself.

So, **restart the rails console** using either method and we can load the object we previously created:

```text
c = Codex.find('test-2')
 => #<Codex id: "test-2", title: "On the Equilibrium of Planes", author: "Archimedes of Syracuse">
```

Check and see that to_solr includes the title and author fields.

```text
c.to_solr
 => {"system_create_dtsi"=>"2015-03-28T03:11:45Z", "system_modified_dtsi"=>"2015-03-28T03:11:45Z", "active_fedora_model_ssi"=>"Codex", "has_model_ssim"=>["Codex"], :id=>"test-2", "object_profile_ssm"=>"{\"id\":\"test-2\",\"title\":\"On the Equilibrium of Planes\",\"author\":\"Archimedes of Syracuse\"}", "title_tesim"=>["On the Equilibrium of Planes"], "author_tesim"=>["Archimedes of Syracuse"]} 
```
Now when you call `.to_solr` on a codex it returns a solr document with fields named `title_tesim` and `author_tesim` that contain your title and author values.  Those are the field names that we will add to Blacklight's queries in [[Lesson - Make Blacklight Return Search Results]].


### Step 9: Re-index an object in Solr

Now we'll call the `update_index` method, which republishes the Solr document using the changes we've made.

```text
c.update_index
 => {"responseHeader"=>{"status"=>0, "QTime"=>44}}
```

If you refresh the document result from solr ([[http://localhost:8983/solr/hydra-development/select?q=test-2]]) you should see that these fields have been added to the solr_document:

```xml
<arr name="title_tesim">
  <str>On the Equilibrium of Planes</str>
</arr>
<arr name="author_tesim">
  <str>Archimedes of Syracuse</str>
</arr>

```

**Aside:** The strange suffixes on the field names are provided by [solrizer](http://github.com/projecthydra/solrizer). You can read about them in the [solrizer documentaton](https://github.com/projecthydra/hydra-head/wiki/Solr-Schema). In short, the **_tesim** suffix tells Solr to treat the values as _**t**ext_ in the _**e**nglish_ language that should be _**s**tored_, _**i**ndexed_ and allowed to be _**m**ultivalued_. This _tesim suffix is a useful catch-all that gets your searches working predictably with minimal fuss. As you encounter cases where you need to index your content in more nuanced ways, there are ways to change these suffixes in order to achieve different results in Solr.

#### Why doesn't the Book show up in Blacklight?

Now your object is indexed properly, but it **still won't show up in Blacklight's search results** until you've turned off access controls and added the appropriate fields to Blacklight's queries.  We cover those in the next lesson.

### Step 10: Commit your changes

Now that we've got our model working, it's a great time to commit to git:

```text
git add .
git commit -m "Create a codex model and a datastream"
```

# Next Step
Go on to [[Lesson - Make Blacklight Return Search Results]] or return to the [[Dive into Hydra]] page.

If you want to learn about OM Terminologies and how they work, visit the [Tame your XML with OM](https://github.com/projecthydra/om/wiki/Tame-your-XML-with-OM) Tutorial.