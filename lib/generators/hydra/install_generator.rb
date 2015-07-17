require 'rails/generators'

module Hydra
  class InstallGenerator < Rails::Generators::Base
    desc 'Generate a new hydra project'

    def run_other_generators
      Bundler.with_clean_env do
        generate("blacklight:install --devise")
        generate('hydra:head -f')
        rake('db:migrate')
      end
    end
  end
end
