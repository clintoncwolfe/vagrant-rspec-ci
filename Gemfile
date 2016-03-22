source 'https://rubygems.org'

group :development do
  if ENV['VAGRANT_VERSION']
    gem 'vagrant', git: 'https://github.com/mitchellh/vagrant.git', tag: ENV['VAGRANT_VERSION']
  else
    gem 'vagrant', git: 'https://github.com/mitchellh/vagrant.git'
  end
end

group :plugins  do
  gem 'vagrant-rspec-ci', path: '.'
end
