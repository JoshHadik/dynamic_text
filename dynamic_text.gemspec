$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "dynamic_text/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "dynamic_text"
  spec.version     = DynamicText::VERSION
  spec.authors     = ["Josh Hadik"]
  spec.email       = ["josh.hadik@gmail.com"]
  spec.homepage    = "https://github.com/JoshHadik/dynamic_text"
  spec.summary     = "A light-weight gem for adding content editable text to a rails project."
  spec.description = "dynamic_text allows you to easily integrate content-editable HTML divs for a specific attribute of a specific resource."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.test_files = Dir["spec/**/*"]

  spec.add_dependency "rails", "~> 5"
  spec.add_dependency "configuron", "~> 0.0.1"

  spec.add_development_dependency 'pg'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'capybara'
  spec.add_development_dependency 'factory_bot_rails'
  spec.add_development_dependency 'pry'
end
