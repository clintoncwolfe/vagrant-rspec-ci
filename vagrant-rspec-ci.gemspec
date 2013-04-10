#-*-ruby-*-
$:.push File.expand_path(File.join(File.dirname(__FILE__), "lib"))
require "vagrant-rspec-ci"

Gem::Specification.new do |s|
  s.name              = VagrantRspecCI::NAME
  s.version           = VagrantRspecCI::VERSION
  s.authors           = VagrantRspecCI::AUTHOR
  s.email             = VagrantRspecCI::AUTHOR_EMAIL
  s.homepage          = VagrantRspecCI::URL
  s.rubyforge_project = VagrantRspecCI::NAME
  s.summary           = VagrantRspecCI::DESCRIPTION
  s.description       = VagrantRspecCI::DESCRIPTION

  s.add_dependency "vagrant", ">= 0.9.0"
  s.add_dependency "rspec"

  s.files = ["README.md"] + Dir["lib/**/*.*"]
end
