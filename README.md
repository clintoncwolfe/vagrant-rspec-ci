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

## Authors

* Michael Paul Thomas Conigliaro <mike [at] conigliaro [dot] org>
