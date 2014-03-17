When you run the hydra generator (e.g. rails generatate hydra:head) the following files will be generated into your project:
```
      create  fedora_conf
      create  fedora_conf/conf/development/fedora.fcfg
      create  fedora_conf/conf/test/fedora.fcfg
      create  solr_conf
      create  solr_conf/conf/schema.xml
      create  solr_conf/conf/solrconfig.xml
      create  solr_conf/solr.xml
```

These files are configuration for the 4.0 version of solr and the 3.6.1 version of fedora. You should check these into your SCM.  If you need to change the configuration you should edit them in this directory and then copy them into your solr/fedora deployment.  If you are using hydra-jetty you can just call `rake jetty:config` to copy them into place.

If you need a configuration suitable for a 3.6.0 version of solr, try these:
* [[https://github.com/projecthydra/hydra-head/blob/4.1.x/solr_conf/conf/schema.xml]]
* [[https://github.com/projecthydra/hydra-head/blob/4.1.x/solr_conf/conf/solrconfig.xml]] 