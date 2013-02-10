define puppet::config(
  $config,
  $dbadapter = undef,
  $dbpasswd  = undef,
  $dbserver  = undef
) {

  file { $name:
    owner   => 'puppet',
    group   => 'puppet',
    mode    => '0644',
    alias   => 'puppet.conf',
    content => template("puppet/puppet.conf.erb"),
    notify  => Service['puppet'],
    require => Package['puppet'],
  }
}