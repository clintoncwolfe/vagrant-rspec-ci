#-*-ruby-*-
$:.push File.expand_path(File.join(File.dirname(__FILE__), "lib"))
require "vagrant-rspec-ci/version"

Gem::Specification.new do |s|
  s.name              = VagrantPlugins::VagrantRspecCI::NAME
  s.version           = VagrantPlugins::VagrantRspecCI::VERSION
  s.authors           = VagrantPlugins::VagrantRspecCI::AUTHOR
  s.email             = VagrantPlugins::VagrantRspecCI::AUTHOR_EMAIL
  s.homepage          = VagrantPlugins::VagrantRspecCI::URL
  s.rubyforge_project = VagrantPlugins::VagrantRspecCI::NAME
  s.summary           = VagrantPlugins::VagrantRspecCI::SUMMARY
  s.description       = VagrantPlugins::VagrantRspecCI::DESCRIPTION

  s.add_dependency "rspec"
  s.add_dependency "capybara"
  s.add_dependency "poltergeist"
  s.add_dependency "rake"
  s.add_dependency "ci_reporter"

  s.files = ["README.md", "LICENSE"] + Dir["lib/**/*.*"]
end
