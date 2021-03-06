# == Class: puppet::params
class puppet::params {

  $client_ensure = 'latest'
  $server_ensure = 'latest'

  case $::osfamily {
    'redhat': {
      $server_package_name = 'puppet-server'
    }
    'debian': {
      $server_package_name = 'puppetmaster'
    }
    default: {
      fail("Module 'puppet' is not currently supported by In&Work on ${::operatingsystem}")
    }
  }
}
