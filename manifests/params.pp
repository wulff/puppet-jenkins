# == Class: jenkins::params
#
# Shared parameters for the Jenkins module.
#
class jenkins::params {
  $user  = 'jenkins'
  $group = 'nogroup'
}