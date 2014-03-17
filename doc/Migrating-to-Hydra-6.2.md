- `Rubydora::Repository#next_pid` has been superseded by `Rubydora::Repository#mint`.

  Example:

  ```ruby
Nokogiri::XML(ActiveFedora::Base.connection_for_pid(0).next_pid(pid_opts)).at_xpath('//xmlns:pid').text
```
  should be:

  ```ruby
ActiveFedora::Base.connection_for_pid('0').mint(pid_opts)
```