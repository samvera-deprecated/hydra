# Hydra

Project Hydra Stack Dependencies

## ngauthier-hydra

If you are looking for the previous hydra gem, a distributed testing framework,
please visit [https://github.com/ngauthier/hydra](https://github.com/ngauthier/hydra).
If you need to previous hydra gem, you can use `gem ngauthier-hydra`.

## Code Status

[![Build Status](https://travis-ci.org/projecthydra/hydra-head.png?branch=master)](https://travis-ci.org/projecthydrahydra/hydra-head)
[![Dependencies Status](https://gemnasium.com/projecthydra/hydra.png)](https://gemnasium.com/projecthydra/hydra)

## Contributing

[Contributing to Project Hydra](CONTRIBUTING.md)

## Developer Wiki

https://github.com/projecthydra/hydra/wiki

## Installation

Add this line to your application's Gemfile:

    gem 'hydra', :require => 'hydra6'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hydra

Then run:

    $ rails g blacklight --devise
    $ rails g hydra:head -f
    $ rake db:migrate