# vagrant-rspec-ci

**vagrant-rspec-ci** is a Vagrant plugin for running integration tests against
your VMs, and produces jUnit formatted reports for consumption by your CI server 
(travis and Jenkins and both can consume this). 

It is based on a fork of Michael Paul Thomas Conigliaro's vagrant-test plugin, with
some (very) breaking changes to make it rpsec-specific and integrate better with ci_reporter
(the jUnit report formatter).  I also removed the internal side of testing, as we didn't 
want to alter the test subject (by installing rspec internally in the VM, for example)

## Installation (Vagrant v1.0.x)

    vagrant gem install vagrant-rspec-ci

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
    <td>config.rspec.enable_ci_reporter</td>
    <td>Boolean - whether to use ci_reporter to format rspec results as jUnit reports.</td>
    <td>true</td>
  </tr>
  <tr>
    <td>config.rspec.suppress_ci_stdout</td>
    <td>ci_reporter improperly registers as a formatter, writes to files, but leaves the doc formatter in place.  This makes for very noisy output.  Set to true (default) to send all STDOUT formatter output from rspec to /dev/null ; set to false when diagnosing a problem, or if you like noise.</td>
    <td>true</td>
  </tr>

  <tr>
    <td>config.rspec.dirs</td>
    <td>Array of directories (relative to vagrant project root) to be used as a search path for external tests.</td>
    <td>['combined/spec_ext", "spec"]</td>
  </tr>
  <tr>
    <td>config.rspec.tests</td>
    <td>List of tests (filenames or globs, expanded in the dirs paths) to be run outside the VM</td>
    <td>[ '*ext_spec.rb' ]</td>
  </tr>
  <tr>
    <td>config.rspec.rspec_bin_path</td>
    <td>Path to rspec command, on VM host</td>
    <td>"rspec"</td>
  </tr>
  <tr>
    <td>config.rspec.reports_dir</td>
    <td>If ci_reporter is enabled, path to write the jUnit XML reports.  Relative to vagrant project dir.</td>
    <td>"rspec_reports"</td>
  </tr>

## Usage

    vagrant rspec [vm-name]

## Change Log

### 0.0.1 (2013-04-09)

* Forked from v0.1.2 of vagrant-test

## License

Copyright (C) 2013 Clinton Wolfe

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

* [Clinton Wolfe](http://ccwolfe.com): Derivative author of vagrant-rspec-ci

* [Michael Paul Thomas Conigliaro](http://conigliaro.org): Original author of vagrant-test
