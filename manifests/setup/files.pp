class nagioscompute::setup::files {
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
}
