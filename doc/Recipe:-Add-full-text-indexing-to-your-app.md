There are number of areas in the Hydra stack that need to be touched to do full-text indexing.  Sufia supports full-text indexing using Apache Tika (which is provided in Apache Solr), and here's how it's implemented. (Note: if you're using Sufia, this is already done for you!)

# Solr

The [Solr schema](https://github.com/projecthydra/sufia/blob/eb714cb91f4ecd49dec67b0e9996dc3d4e918f1a/solr_conf/conf/schema.xml#L174-L175) contains a field called `all_text_timv`.

The [Solr config](https://github.com/projecthydra/sufia/blob/7cedb837b2d6388d81ba7d9a815edc0e4b4c1251/solr_conf/conf/solrconfig.xml#L16-L17) pulls in a bunch of extraction libraries and [adds the `all_text_timv` field to the default qf and pf](https://github.com/projecthydra/sufia/blob/7cedb837b2d6388d81ba7d9a815edc0e4b4c1251/solr_conf/conf/solrconfig.xml#L42-L47). The [ExtractingRequestHandler](https://github.com/projecthydra/sufia/blob/7cedb837b2d6388d81ba7d9a815edc0e4b4c1251/solr_conf/conf/solrconfig.xml#L110-L121) must be enabled as well.

# Extraction libraries

Sufia uses [a rake task](https://github.com/projecthydra/sufia/blob/eb714cb91f4ecd49dec67b0e9996dc3d4e918f1a/sufia-models/lib/tasks/sufia-models_tasks.rake#L27-L96) to download extraction libraries and store them where Solr looks for them.

# Blacklight catalog

The `all_text_timv` field is added to the `all_fields` search qf in the [Catalog controller](https://github.com/projecthydra/sufia/blob/a064489d3cf4d228abf978d7126644e2c653aa5e/lib/generators/sufia/templates/catalog_controller.rb#L125)

# Modeling

Sufia's `GenericFile` model mixes in [a module that knows how to talk to Solr's ExtractingRequestHandler](https://github.com/projecthydra/sufia/blob/a064489d3cf4d228abf978d7126644e2c653aa5e/sufia-models/app/models/concerns/sufia/generic_file/full_text_indexing.rb). (The `#extract_content` method is where that happens.)

# Indexing

Sufia has [an indexing service](https://github.com/projecthydra/sufia/blob/7644ff5b04d66cfe1c4d7bee75a6840eb09eb664/sufia-models/app/services/sufia/generic_file_indexing_service.rb#L10) that takes the output of Apache Tika and indexes it in Solr. (This is the equivalent of overriding `#to_solr` on an ActiveFedora model.)

# Workflow

When a file is uploaded, Sufia spawns [a background job that characterizes the file](https://github.com/projecthydra/sufia/blob/a064489d3cf4d228abf978d7126644e2c653aa5e/sufia-models/app/jobs/characterize_job.rb#L7). The `#characterize` method calls [#append_metadata](https://github.com/projecthydra/sufia/blob/a064489d3cf4d228abf978d7126644e2c653aa5e/sufia-models/app/models/concerns/sufia/generic_file/characterization.rb#L75). That method in turn calls the `#extract_content` method which hits Apache Tika via the Solr API.
