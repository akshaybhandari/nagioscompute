class nagioscompute::setup {
  file { '/etc/nagios/nrpe.d/nrpe_command.cfg':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Service['nagios-nrpe-server'],
    require => Package['nagios-nrpe-server'],
  }
  class { 'nagioscompute::setup::host':
    require => [ File['/etc/nagios/nrpe.cfg'], Package['nagios-nrpe-plugin', 'nagios-nrpe-server'] ],
  } ->
  class { 'nagioscompute::setup::services':
    service_list          => $::nagioscompute::service_list,
  } ->
  class { 'nagioscompute::setup::files': } ->
  class { 'nagioscompute::setup::commands':
    service_list          => $::nagioscompute::service_list,
  }
}
