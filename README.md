# Hydra
This gem provides a distribution-like snapshot of all dependencies within the core Hydra technology stack. The components of the stack are as follows:

* [ldp](https://github.com/projecthydra/ldp) - Linked Data Platform client library for Ruby
* [solrizer](https://github.com/projecthydra/solrizer) - translates indexing directives into Solr field names
* [om](https://github.com/projecthydra/om) - a library for defining templates for xml metadata formats
* [nom-xml](https://github.com/cbeer/nom-xml) - an alternative to om
* [active-fedora](https://github.com/projecthydra/active_fedora) - a Ruby gem for creating and managing objects in Fedora and Solr
* [active-triples](https://github.com/ActiveTriples/ActiveTriples) - a Ruby gem that provides an ActiveFedora-like interface for RDF data.
* [blacklight](https://github.com/projectblacklight/blacklight) - web front end for Solr document discovery (search)
* [hydra-head](https://github.com/projecthydra/hydra-head) - integration between Blacklight and ActiveFedora. Provides access controls and gated searching.
* [Fcrepo Wrapper](https://github.com/cbeer/fcrepo_wrapper) - Utility for wrapping tasks with a Fedora instance, for use in development and testing. Replaces role of [hydra-jetty](https://github.com/projecthydra/hydra-jetty)
* [Solr Wrapper](https://github.com/cbeer/solr_wrapper) - Utility for wrapping tasks with a Solr instance, for use in development and testing. Replaces role of [hydra-jetty](https://github.com/projecthydra/hydra-jetty)

Additionally, versions are locked to the following transitive dependencies, as they are critial to the stack:
* [Nokogiri](http://nokogiri.org/)
* [Ruby on Rails](http://rubyonrails.org/)
* [RSolr](https://github.com/rsolr/rsolr)

## Code Status
[![Gem Version](https://badge.fury.io/rb/hydra.png)](http://badge.fury.io/rb/hydra)

## For Developers

* [Tutorial: Dive Into Hydra](https://github.com/projecthydra/hydra/wiki/Dive-into-Hydra)
* [Developer Wiki](https://github.com/projecthydra/hydra/wiki)

## Contributing
* [Contributing to Project Hydra](CONTRIBUTING.md)

## Installation

You may want to consider the [Dive Into Hydra Tutorial](https://github.com/projecthydra/hydra/wiki/Dive-into-Hydra).
Or perhaps you want a little more self-directed.
If so:

Add this line to your application's Gemfile:

    gem 'hydra'

And then execute:

    $ bundle

Then run:

    $ rails g hydra:install

## Acknowledgements
The initial insights and ideas behind producting a "distro-like" gem to reflect a particular known-good,
point-in-time state of the Hydra technology stack resulted from a series of community discussions online,
in e-mail, and in person during the period from December 2012 through June 2013.  Huge thanks are owed to
Jeremy Friesen (Notre Dame), Drew Myers (WGBH), Justin Coyne (Data Curation Experts),
and Mark Bussey (Data Curation Experts) for activating on these ideas and implementing this gem.

A giant thank you is also owed to [Nick Gauthier](https://github.com/ngauthier) for offering up the Hydra gem name.

### ngauthier-hydra
If you are looking for the previous hydra gem, a distributed testing framework,
please visit [https://github.com/ngauthier/hydra](https://github.com/ngauthier/hydra).
If you need to previous hydra gem, you can use `gem ngauthier-hydra`.

# Project Hydra
This software has been developed by and is brought to you by the Hydra community.  Learn more at the
[Project Hydra website](http://projecthydra.org)

![Project Hydra Logo](https://github.com/uvalib/libra-oa/blob/a6564a9e5c13b7873dc883367f5e307bf715d6cf/public/images/powered_by_hydra.png?raw=true)
