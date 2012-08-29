# == Define: jenkins::plugin
#
# Use this resource type to install Jenkins plugins.
#
# === Parameters
#
# [*repository*]
#   The Git repository containing the job definition. Mandatory.
#
# [*jenkins_user*]
#   The username of the jenkins user. Defaults to 'jenkins'.
#
# [*jenkins_groups*]
#   The group of jenkins. Defaults to 'nogroup'.
#
# === Examples
#
#   jenkins::plugin { 'phing': }
#
define jenkins::plugin(
  $plugin_name   = $title,
  $version       = 'UNSET',
  $jenkins_user  = 'UNSET',
  $jenkins_group = 'UNSET'
) {
  $jenkins_user_real = $jenkins_user ? {
    'UNSET' => $jenkins::params::user,
    default => $jenkins_user,
  }

  $jenkins_group_real = $jenkins_group ? {
    'UNSET' => $jenkins::params::group,
    default => $jenkins_group,
  }

  $plugin_name_real  = "${plugin_name}.hpi"
  $plugin_dir        = '/var/lib/jenkins/plugins'
  $plugin_parent_dir = '/var/lib/jenkins'

  if $version != 'UNSET' {
    $base_url = "http://updates.jenkins-ci.org/download/plugins/${name}/${version}/"
  }
  else {
    $base_url = 'http://updates.jenkins-ci.org/latest/'
  }

  if !defined(File[$plugin_dir]) {
    file { [$plugin_parent_dir, $plugin_dir]:
      ensure  => directory,
      owner   => $jenkins_user_real,
      group   => $jenkins_user_group,
      require => Package['jenkins'],
    }
  }

  exec { "jenkins-plugin-download-${name}":
    command => "wget --no-check-certificate ${base_url}${plugin_name_real}",
    cwd     => $plugin_dir,
    user    => $jenkins_user_real,
    unless  => "test -f ${plugin_dir}/${plugin_name_real}",
    notify  => Service['jenkins'],
    require => [Package['jenkins'], File[$plugin_dir]],
  }
}