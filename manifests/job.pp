# == Define: jenkins::job
#
# This resource type adds a Jenkins job template.
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
#   jenkins::job { 'job-template':
#     repository => 'git://github.com/jobs/job-template.git',
#   }
#
define jenkins::job(
  $job_name      = $title,
  $repository    = 'UNSET',
  $jenkins_user  = 'UNSET',
  $jenkins_group = 'UNSET'
) {
  if $repository == 'UNSET' {
    fail('repository parameter is required')
  }

  $jenkins_user_real = $jenkins_user ? {
    'UNSET' => $jenkins::params::user,
    default => $jenkins_user,
  }

  $jenkins_group_real = $jenkins_group ? {
    'UNSET' => $jenkins::params::group,
    default => $jenkins_group,
  }

  exec { "jenkins-job-${job_name}":
    command => "git clone ${repository} ${job_name} && chown -R ${jenkins_user_real}:${jenkins_group_real} ${job_name}",
    cwd     => '/var/lib/jenkins/jobs',
    creates => "/var/lib/jenkins/jobs/${job_name}",
    require => Package['jenkins'],
  }
}