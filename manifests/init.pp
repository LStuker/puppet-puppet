# == Class: puppet
#
# This class installs and manages the Puppet client deamon 
# Inspired by https://github.com/elasticdog/puppet-sandbox
#
# === Parameters
#
# [*ensure*]
#   What state the package should be in. Defaults to +latest+. Valid values are
#   +present+ (also called +installed+), +absent+, +purged+, +held+, +latest+,
#   or a specific version number.
#
# === Variables
#
# === Actions
#
# - Add puppetlabs repo
# - Install Puppet package
# - Ensure puppet-agent daemon is running
#
# === Examples
#
#   class { 'puppet:': }
#
#   class { 'puppet:':
#     ensure => 'puppet-2.7.17-1.el6',
#   }
#
# === Authors
#
# LStuker <lstuker@gmail.com>
# elasticdog / puppet-sandbox
#
# === Copyright
#
# Copyright 2013 Lucien Stuker, unless otherwise noted.
#
class puppet(
  $ensure = $puppet::params::client_ensure
) inherits puppet::params {

  class { 'puppet::repo': }

  package { 'puppet':
    ensure    => $ensure,
    require   => Class['puppet::repo'],
  }

  puppet::config { '/etc/puppet/puppet.conf':
    config => 'agent',
  }

  service { 'puppet':
    enable     => true,
    ensure     => running,
    hasrestart => true,
    hasstatus  => true,
    require    => [ File['puppet.conf'], Package['puppet'] ]
  }

}
