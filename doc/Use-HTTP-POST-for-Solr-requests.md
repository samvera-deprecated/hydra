Requires: Blacklight 4.6.3 or higher

To use HTTP POST in a specific controller (e.g., CatalogController):

```ruby
configure_blacklight do |config|
  config.http_method = :post
end
```

To set HTTP POST as the *default* (i.e, for all instances of `Blacklight::Configuration`) add the following to a Rails initializer (or similar mechanism):

```ruby
Blacklight::Configuration.default_values[:http_method] = :post
```

NOTE: This solution does *not* change the behavior of `ActiveFedora::SolrService`.