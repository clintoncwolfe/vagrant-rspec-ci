# vagrant-test

**vagrant-test** is a simple Vagrant plugin for running integration tests on
your VMs. There are several similar projects related to testing Chef/Puppet
configurations, but to my knowledge, none of them provide a simple way to run
the typical "internal" tests as well as "external" tests (i.e. run from outside
the VM) in order to verify remote connectivity.

This project served as a way for me to learn how to write a Vagrant plugin, and
due to its extreme simplicity, it is also CM/test framework agnostic (a useful
feature, in my opinion).

## Installation

    gem install vagrant-test

## Configuration

The following options can be used within the `Vagrant::Config.run` block of
your Vagrantfile:

<table>
  <tr>
    <th>Option</th>
    <th>Description</th>
    <th>Default value</th>
  </tr>
  <tr>
    <td>test.command</td>
    <td>Command used to run tests</td>
    <td>"rspec -f doc"</td>
  </tr>
  <tr>
    <td>test.dir</td>
    <td>Root directory for all tests</td>
    <td>"spec"</td>
  </tr>
  <tr>
    <td>test.internal_tests</td>
    <td>List of tests to be run by the VM</td>
    <td>[]</td>
  </tr>
  <tr>
    <td>test.external_tests</td>
    <td>List of tests to be run by the host system against the VM</td>
    <td>[]</td>
  </tr>
</table>

## Usage

    vagrant test [vm-name]

## Change Log

### 0.1.0 (2012-02-29)

* Initial public release

## License

Copyright (C) 2012 Michael Paul Thomas Conigliaro

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

## Credits

* [Michael Paul Thomas Conigliaro](http://conigliaro.org): Original author
