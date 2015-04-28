class nagioscompute::setup::files {
  file { "nagios_privileged_${hostname}":
    ensure => directory,
    path   => '/usr/lib/nagios/plugins/privileged/',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    require => Package['nagios-nrpe-server'],
  }
  file { "check_memory.sh_${hostname}":
    ensure => present,
    path   => '/usr/lib/nagios/plugins/check_memory.sh',
    source => 'puppet:///modules/nagioscompute/check_memory.sh',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }
  file { "check_cpu.sh_${hostname}":
    ensure => present,
    path   => '/usr/lib/nagios/plugins/check_cpu.sh',
    source => 'puppet:///modules/nagioscompute/check_cpu.sh',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }
  file { "check_vm_states.sh_${hostname}":
    ensure  => present,
    path    => '/usr/lib/nagios/plugins/privileged/check_vm_states.sh',
    source  => 'puppet:///modules/nagioscompute/check_vm_states.sh',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => File["nagios_privileged_${hostname}"]
  }
  file { "check_service.sh_${hostname}":
    ensure => present,
    path   => '/usr/lib/nagios/plugins/check_service.sh',
    source => 'puppet:///modules/nagioscompute/check_service.sh',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }
}
