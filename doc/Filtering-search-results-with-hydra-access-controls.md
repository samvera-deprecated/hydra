In you catalog_controller.rb add the following lines:

```
include Hydra::Controller::ControllerBehavior
before_filter :enforce_show_permissions, :only=>:show
CatalogController.solr_search_params_logic += [:add_access_controls_to_solr_params]
```

Additionally, if you want to remove FileAssets from search results you can add:
```
CatalogController.solr_search_params_logic += [:exclude_unwanted_models]
```

Running the generator: `rails g hydra:head`  typically takes care of this for you.


