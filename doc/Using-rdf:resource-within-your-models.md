Some data models may call for adding properties to objects that consist of URI references using the `rdf:resource` syntax. For example, you may want to define an object's language by reference to a standard list available online, such as that supplied by Library of Congress. In this example, we will add a language property to the Book example from Dive Into Hydra which consists of a URI reference.

First, you add the required property to the model:

```ruby
property :language, predicate: ::RDF::DC.language, multiple: false
```

Then you add a getter and setter method:

```ruby
def language_uri=(uri)
  self.language = ::RDF::URI.new(uri) if uri.present?
end

def language_uri
  self.language.to_term.value unless language.nil?
end
```

In your rails console try assigning a language to an object, for example:

```
b = Book.new
b.language_uri = "http://id.loc.gov/vocabulary/languages/abk"
b.language_uri
 => "http://id.loc.gov/vocabulary/languages/abk" 
b.language
 => #<ActiveTriples::Resource:0x42c2258(default)> 
b.resource.dump(:rdf)
 => "<?xml version='1.0' encoding='utf-8' ?>
<rdf:RDF xmlns:ns0='info:fedora/fedora-system:def/model#' xmlns:ns1='http://purl.org/dc/terms/' xmlns:rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#'>
<rdf:Description rdf:about=''>
<ns1:language rdf:resource='http://id.loc.gov/vocabulary/languages/abk' />
<ns0:hasModel>Book</ns0:hasModel>
</rdf:Description>
</rdf:RDF>" 
```

As you can see, the link has been added to the property as an `rdf:resource` attribute rather than as a value. If you are updating objects via a web form, you will use the language_uri attribute in the form rather than the language attribute. You will also need to add the `language_uri` field to the whitelisted parameters in the controller. 



