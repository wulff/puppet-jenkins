Puppet module for Jenkins
=========================

This module allows you to install the Jenkins continuous integration server as
well as any job templates and plugins you might need.

Basic usage
-----------

Install Jenkins:

    class { 'jenkins': }

Install a Jenkins job template from a Git repository:

    jenkins::job { 'drupal-template':
      repository => 'git://github.com/wulff/jenkins-drupal-template.git',
    }

Install a Jenkins plugin:

    jenkins::plugin { 'phing': }

Notes
-----

 * Requires the PuppetLabs APT module
 * Based on https://github.com/rtyler/puppet-jenkins

Authors
-------

Morten Wulff <wulff@ratatosk.net>