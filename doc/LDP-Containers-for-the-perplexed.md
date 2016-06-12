This document is a summary of the basic differences between the different kind of containers that Linked Data Platform (LDP) supports.

LDP specifies three types of containers: 
  1. Basic Container
  2. Direct Container
  3. Indirect Container. 

This document describes the differences between the three types of containers by showing what triples are added by an LDP Server when adding a new element to each kind of container. 

In particular we assume we have a fictitious blog entry (`/blog/entry1/`) and we want to add a comment to it. We start by showing what happens if the blog entry is a Basic Container, then we show what happens if the blog entry was instead a Direct Container, and lastly if it was an Indirect Container.

This document assumes familiarity with concepts described in the LDP Spec (http://www.w3.org/TR/ldp/#ldpdc) and the examples described in the LDP Primer (http://www.w3.org/TR/ldp-primer/). If you haven't read those documents this document might not make much sense. However, if you read those documents and still have some doubts about the differences between the different kind of containers this document should help to clarify them.


## Basic Container
Assuming we have a **Basic Container** issuing an `HTTP GET /blog/entry1/` will return something like this:

    </blog/entry1/> a ldp:Container .
    </blog/entry1/> dc:title "First blog entry" .

To add an object to this container (for example, a comment to this blog entry) we would issue an `HTTP POST /blog/entry1` with `Slug: comment1` which will result in 

  1. A new resource created at `/blog/entry1/comment1`
  2. A new triple (with predicate `ldp:contains`) added to `/blog/entry1/`

Issuing an `HTTP GET /blog/entry1/comment1` will return the new resource created, something like this:

    </blog/entry1/comment1/> a ldp:RDFSource .
    </blog/entry1/comment1/> dc:title "this is a new comment" .

Because `/blog/entry1/` is a Basic Container the LDP Server will also automatically add a new triple to it. Issuing an `HTTP GET /blog/entry1/` now returns:

    </blog/entry1/> a ldp:Container .
    </blog/entry1/> dc:title "First blog entry" .
    </blog/entry1/> ldp:contains </blog/entry1/comments1> .

The important thing to notice is that by posting to a Basic Container, the LDP server automatically adds a triple with `ldp:contains` predicate pointing to the new resource created. 


## Direct Container
An Direct Container behaves a lot like a Basic Container but with some additional features. In a Direct Container we get to specify two additional attributes that the LDP Server will use to automatically add triples to *another resource* when posting new elements to the container. The *membershipResource* attribute will let the LDP Server know the URI of this other resource and the *hasMemberRelation* will indicate the predicate these new triples will have. 

Assuming `/blog/entry1/` is a **Direct Container** created with *membershipResource* `/blog/comments` and *hasMemberRelation* `hasComment` 

Issuing an `HTTP GET /blog/entry1/` returns

    </blog/entry1/> a ldp:DirectContainer .
    </blog/entry1/> ldp:membershipResource </blog/comments> .
    </blog/entry1/> ldp:hasMemberRelation hasComment .
    </blog/entry1/> dc:title "First blog entry" .

Issuing an `HTTP POST /blog/entry1/` with `Slug: comment1` will result in 

  1. A new resource created at `/blog/entry1/comment1`
  2. A new triple (predicate `ldp:contains`) added to `/blog/entry1/`
  3. A new triple (predicate `hasComment`) added to `/blog/comments`

The first two items are identical to what we saw in the Basic Container example. Issuing an `HTTP GET /blog/entry1/comment1` will return the new resource created, something like this:

    </blog/entry1/comment1/> a ldp:RDFSource .
    </blog/entry1/comment1/> dc:title "this is a new comment" .

Issuing an `HTTP GET /blog/entry1/` will show the new triple with `ldp:contains` predicate, just like in the Basic Container example:

    </blog/entry1/> a ldp:DirectContainer .
    </blog/entry1/> ldp:membershipResource </blog/comments> .
    </blog/entry1/> ldp:hasMemberRelation hasComment .
    </blog/entry1/> ldp:contains </blog/entry1/comments1> .

The third item is what sets the Direct Container appart from the Basic Container. Issuing an `HTTP GET /blog/comments` will show also a new triple in this resource but this one with predicate `hasComment` as indicated by the `hasMembershipRelation` triple on the container: 

    </blog/comments> hasComment </blog/entry1/comment1>

Notice how a new triple was added to *a totally different resource*. In this case the triple was added to `/blog/comments` with predicate `hasComment` because that's what the *membershipResource* and *hasMemberRelationship* of the Direct Container specify.

One thing to notice is that the resource added to `/blog/comments` will always be the URI of the newly created resource. In our example `/blog/comments` will get a new triple pointing to `/blog/entry1/comment1`. In other words, in a Direct Container we can configure the subject and the predicate of the new triple, but not the object. [Technically speaking this is not accurate, it is possible to revert the relationship by using is predicate *isMemberOfRelation* in the Direct Container instead of *hasMemberRelation* but for the sake of simplicity I am not going to dive into that scenario in this document.]


## Indirect Container
The Indirect Container is a bit like the Direct Container but with an extra twist. In an Indirect Container we can specify the subject, predicate, *and the object* of the new triple what will be added.

Assumming `/blog/entry1/` is an **Indirect Container** created with *membershipResource* `/blog/comments`, *hasMemberRelation* `hasComment`, and *insertedContentRelation* `theComment`.

Issuing an `HTTP GET /blog/entry1/` returns

    </blog/entry1/> a ldp:IndirectContainer .
    </blog/entry1/> ldp:membershipResource </blog/comments> .
    </blog/entry1/> ldp:hasMemberRelation hasComment .
    </blog/entry1/> ldp:insertedContentRelation theComment .
    </blog/entry1/> dc:title "First blog entry" .

When issuing an `HTTP POST` to an Indirect Container we need to specify some additional information for the LDP Server to be able to determine the *object* that will be used when adding the new triple to the `ldp:membershipResource`. In our particular example the body must contain an RDF triple with predicate `theComment`. For example, let's assume that we issue an `HTTP POST /blog/entry1/` with `Slug: comment1` and the following triple in the body of the POST request:

    <> theComment </blog/extras/first/text> .

The result of this HTTP will be 

  1. A new resource created at `/blog/entry1/comment1`
  2. A new triple (predicate `ldp:contains`) added to `/blog/entry1/`
  3. A new triple (predicate `hasComment`, object `</blog/extras/first/text>`) added to `/blog/comments`

The first two actions are identical to what we saw in Basic Container and Direct Container so I will not elaborate on them. 

The third action is what is interesting in Indirect Containers. If we issue an `HTTP GET /blog/comments` we will see that a new triple has been added to it, and it will look as follows:

    </blog/comments> hasComment </blog/extras/first/text>

The subject of this triple (`/blog/comments`) and the predicate (`hasComment`) is what the *membershipResource* and the *hasMemberRelation* properties of the container indicated, similar to what we saw for Direct Containers. 

However, the object of this new triple (`/blog/extras/first/text`) **is not the newly created `/blog/entry1/commment1` resource**. Instead, the object of this new triple is the object indicated in the triple with predicate `theComment` in the body of the request: `/blog/extras/first/text`. 

When adding a new resource to an Indirect Container, the LDP Server looks at the body of the request for a triple with the same predicate as the *insertedContentRelation* property and picks from that triple the value to use as the object in the new triple.

## LDP PDCM In Action
Andrew Woods has posted a great tutorial that goes in more detail on how LDP containers can be used in a real life example. On [LDP-PCDM-F4 In Action](https://wiki.duraspace.org/display/FEDORA4x/LDP-PCDM-F4+In+Action) he shows how to represent the Portland Common Data Model (PCDM) using LDP in Fedora 4. His tutorial not only shows the differences between each of the containers but also provides cURL commands to create them in Fedora 4.

Andrew's tutorial also addresses reversing the triples that are created in a Direct Container (by using `ldp:isMemberOfRelation` as opposed to `ldp:hasMemberRelation`) which is something that I explicitly skipped on this document.

If you follow Andrew's tutorial with a plain-vanilla installation of Fedora 4 you might also find useful [Adam Wead scripts](https://github.com/awead/ldp-pcdm). However, if you are using an installation of Fedora via Hydra Jetty you will need to tweak the URLs provided by Andrew. You can find [here](https://github.com/hectorcorrea/ldp_pcdm_f4_in_action) the commands that I used to run his tutorial on a Fedora 4 installed via Hydra Jetty. 
