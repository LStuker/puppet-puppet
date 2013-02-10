# == Class: puppet::repo
#
# This class set the repo puppetlabs for apt and yum
#
class puppet::repo {

  case $::osfamily {
    'redhat': {

      file { "/etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs":
        owner   => root,
        group   => root,
        mode    => 0644,
        source  => "puppet:///modules/puppet/RPM-GPG-KEY-puppetlabs"
      }

      # can't rely on $lsbmajdistrelease being available on CentOS, and lsb's
      # dependencies are huge, so don't force installation of the package
      $os_release_major_version = regsubst($operatingsystemrelease, '^(\d+).*$', '\1')
      yumrepo {'puppetlabs-products':
        descr    => "Puppet Labs Products El ${os_release_major_version} - ${hardwareisa}",
        baseurl  => "http://yum.puppetlabs.com/el/${os_release_major_version}/products/${hardwareisa}",
        gpgkey   => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs',
        enabled  => 1,
        gpgcheck => 1,
      }
    }
    'debian': {
      apt::source { 'puppetlabs':
        location   => 'http://apt.puppetlabs.com',
        repos      => 'main',
        key        => '4BD6EC30',
        key_server => 'pgp.mit.edu',
      }
    }
  }

}