# == Class: puppet::server
#
# This class installs and manages the Puppet server daemon.
#
# === Parameters
#
# [*ensure*]
#   What state the package should be in. Defaults to +latest+. Valid values are
#   +present+ (also called +installed+), +absent+, +purged+, +held+, +latest+,
#   or a specific version number.
#
# [*package_name*]
#   The name of the package on the relevant distribution. Default is set by
#   Class['puppet::params'].
#
# === Actions
#
# - All actions from puppet class
# - Configures and manage puppet.conf
# - Configure Puppet to autosign puppet client certificate requests
# - Ensure puppet-master daemon is running
#
# === Requires
#
# puppetlabs/apt
#
# === Sample Usage
#
#   class { 'puppet::server': }
#
#   class { 'puppet::server':
#     ensure => 'puppet-2.7.17-1.el6',
#   }
#
class puppet::server(
  $ensure       = $puppet::params::server_ensure,
  $package_name = $puppet::params::server_package_name
) inherits puppet {


  package { 'puppetmaster':
    ensure    => $ensure,
    name      => $package_name,
    require   => Class['puppet::repo'],
  }

  Puppet::Config['/etc/puppet/puppet.conf']{
    config    => 'master',
    notify    +> Service['puppetmaster'],
    require   +> Package['puppetmaster'],
  }

  # file { 'site.pp':
  #   path    => '/etc/puppet/manifests/site.pp',
  #   owner   => 'puppet',
  #   group   => 'puppet',
  #   mode    => '0644',
  #   source  => 'puppet:///modules/puppet/site.pp',
  #   require => Package[ 'puppetmaster' ],
  # }

  file { 'autosign.conf':
    path    => '/etc/puppet/autosign.conf',
    owner   => 'puppet',
    group   => 'puppet',
    mode    => '0644',
    content => '*',
    require => Package[ 'puppetmaster' ],
  }

  # file { '/etc/puppet/manifests/nodes.pp':
  #   ensure  => link,
  #   target  => '/vagrant/nodes.pp',
  #   require => Package[ 'puppetmaster' ],
  # }

  # # initialize a template file then ignore
  # file { '/vagrant/nodes.pp':
  #   ensure  => present,
  #   replace => false,
  #   source  => 'puppet:///modules/puppet/nodes.pp',
  # }

  service { 'puppetmaster':
    enable     => true,
    ensure     => running,
    hasrestart => true,
    hasstatus  => true,
    require    => [ File['puppet.conf'], Package['puppetmaster'] ]
  }

}
