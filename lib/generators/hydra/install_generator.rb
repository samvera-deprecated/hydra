require 'rails/generators'

module Hydra
  class InstallGenerator < Rails::Generators::Base
    desc 'Generate a new hydra project'

    def run_other_generators
      generate("blacklight --devise")
      generate('hydra:head -f')
      rake('db:migrate')
    end
  end
end