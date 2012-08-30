# == Class: jenkins
#
# This class installs the Jenkins continuous integration server.
#
# === Parameters
#
# [*jenkins_user*]
#   The username of the jenkins user. Defaults to 'jenkins'.
#
# [*jenkins_groups*]
#   The group of jenkins. Defaults to 'nogroup'.
#
# [*version*]
#   The version of the package to install. Takes the same arguments as the
#   'ensure' parameter. Defaults to 'present'.
#
# === Examples
#
#   class { 'jenkins': }
#
class jenkins(
  $jenkins_user  = 'UNSET',
  $jenkins_group = 'UNSET',
  $version       = present
) {
  include jenkins::params

  $jenkins_user_real = $jenkins_user ? {
    'UNSET' => $jenkins::params::user,
    default => $jenkins_user,
  }

  $jenkins_group_real = $jenkins_group ? {
    'UNSET' => $jenkins::params::group,
    default => $jenkins_group,
  }

  if ! defined(Apt::Source['jenkins']) {
    apt::source { 'jenkins':
      location    => 'http://pkg.jenkins-ci.org/debian',
      release     => '',
      repos       => 'binary/',
      key         => 'D50582E6',
      key_server  => 'http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key',
      include_src => false,
    }
  }

  package { 'jenkins':
    ensure  => $version,
    require => Apt::Source['jenkins'],
  }

  service { 'jenkins':
    ensure  => running,
    enable  => true,
    require => Package['jenkins'],
  }
}