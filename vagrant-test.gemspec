$:.push File.expand_path(File.join(File.dirname(__FILE__), "lib"))
require "vagrant-test"

Gem::Specification.new do |s|
  s.name              = VagrantTest::NAME
  s.version           = VagrantTest::VERSION
  s.authors           = VagrantTest::AUTHOR
  s.email             = VagrantTest::AUTHOR_EMAIL
  s.homepage          = VagrantTest::URL
  s.rubyforge_project = VagrantTest::NAME
  s.summary           = VagrantTest::DESCRIPTION
  s.description       = VagrantTest::DESCRIPTION

  s.add_dependency "vagrant", "~> 0.9.0"
  s.add_dependency "rspec"

  s.files = ["README.md"] + Dir["lib/**/*.*"]
end
