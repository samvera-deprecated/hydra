This Tutorial is known to work with hydra-head version 6.0.0..  
_Please update this wiki to reflect any other versions that have been tested._

# Steps

Given a book whose permissions look like this:
```text
puts book.permissions
{:type=>"group", :access=>"discover", :name=>"group2"}
{:type=>"group", :access=>"read", :name=>"group3"}
{:type=>"group", :access=>"read", :name=>"group9"}
{:type=>"group", :access=>"read", :name=>"group8"}
{:type=>"user", :access=>"read", :name=>"user3"}
{:type=>"user", :access=>"edit", :name=>"bob1"}
{:type=>"user", :access=>"edit", :name=>"sally2"}
```

The permissions will be written into the rightsMetadata datstream like so
```xml
puts book.rightsMetadata.to_xml
<rightsMetadata xmlns="http://hydra-collab.stanford.edu/schemas/rightsMetadata/v1" version="0.1">
  <copyright>
    <human type="title"/>
    <human type="description"/>
    <machine type="uri"/>
  </copyright>
  <access type="discover">
    <human/>
    <machine>
      <group>group2</group>
    </machine>
  </access>
  <access type="read">
    <human/>
    <machine>
      <group>group3</group>
      <group>group9</group>
      <group>group8</group>
      <person>user3</person>
    </machine>
  </access>
  <access type="edit">
    <human/>
    <machine>
      <person>bob1</person>
      <person>sally2</person>
    </machine>
  </access>
  <embargo>
    <human/>
    <machine/>
  </embargo>
</rightsMetadata>
```

If we remove the nodes that aren't relevant to this lesson, the XML looks like this:

```xml
<rightsMetadata xmlns="http://hydra-collab.stanford.edu/schemas/rightsMetadata/v1" version="0.1">
  <access type="discover">
    <machine>
      <group>group2</group>
    </machine>
  </access>
  <access type="read">
    <machine>
      <group>group3</group>
      <group>group9</group>
      <group>group8</group>
      <person>user3</person>
    </machine>
  </access>
  <access type="edit">
    <machine>
      <person>bob1</person>
      <person>sally2</person>
    </machine>
  </access>
</rightsMetadata>
```

As you can see, group ids are put into `<group>` nodes and user ids are put into `<person>` nodes.  The type of access being granted is decided by the @type attribute on the `<access>` nodes.

The intermediary `<machine>` node is meant to allow you to insert human-readable information into the 'access/human' node while inserting the machine-readable assertions into 'access/machine' node.

# Next Step
Go on to [[Lesson: Indexing Hydra Rights Metadata into Solr]] or return to the [[Access Controls with Hydra]] tutorial.