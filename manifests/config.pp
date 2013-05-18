# == Class: jenkins::config
#
#
# 
# === Examples
#
#   class { 'jenkins::config': }
#
class jenkins::config(
  $slaves = undef
) {

  file { '/var/lib/jenkins/config.xml':
    content => template('jenkins/config.erb'),
    owner => jenkins,
    group => nogroup,
    require => Package['jenkins'],
  }

  file { '/var/lib/jenkins/credentials.xml':
    source  => 'puppet:///modules/jenkins/credentials.xml',
    owner => jenkins,
    group => nogroup,
    require => Package['jenkins'],
  }

}
