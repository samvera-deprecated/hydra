Here are some projects we the community could get started if we had some time to hack:

- Memory adapter for active fedora.
- AngularJS editor (replacement/substitute for hydra-editor)
- Put [Oargun](https://github.com/curationexperts/oargun) metadata into a plugin/add-on for Sufia
- Linked Data Caching - Explore Apache Stanbol maybe?
- A recipe for deploying the stack with Docker
- Service wrapper for that can startup multiple services (e.g. Solr 5, Fedora 4, Marmotta?) with one command
- Port the LDP gem to Hurley (from Faraday) https://github.com/lostisland/hurley
- Bring sufia's various metadata forms into a state of consistency / uniformity (post-upload form, single file edit, batch edit all have different UX and present fields in different orders) 
- Use Raptor (https://ruby-rdf.github.io/rdf-raptor/) to speed up ActiveFedora
- Store ACLs as hash code resources. This should reduce the number of LDP requests.


Past projects:
- Extract the shared methods out of ActiveFedora::Base (Core) and ActiveFedora::File. Several commits around 24 June 2015 https://github.com/projecthydra/active_fedora/commit/bc551d68f81d9dc10f45f652cd01dba36a158897
- Replace Sufia's queuing with ActiveJob (done for Sufia 7 / CurationConcerns)
- Replace jetty_wrapper with solr_wrapper and fcrepo_wrapper (Spring 2016 dev retreat)
