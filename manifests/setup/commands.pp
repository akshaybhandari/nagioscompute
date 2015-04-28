class nagioscompute::setup::commands (
  $service_list = ['openvswitch-switch', 'nova-compute', 'libvirt-bin'],
  $os_type = linux,
) {
  case $::osfamily {
    'redhat': {
      $sudo_path = '/bin/sudo'
    }
    'debian': {
      $sudo_path = '/usr/bin/sudo'
    }
    default: { fail("No such osfamily: ${::osfamily} yet defined") }
  }
  #OpenStack related checks
  each($service_list) |$service| {
    file_line { "check_service_${service}_${hostname}":
      ensure  => present,
      path    => '/etc/nagios/nrpe.d/nrpe_command.cfg',
      line    => "command[check_service_${service}]=/usr/lib/nagios/plugins/check_service.sh -o ${os_type} -s ${service}",
      require => File['/etc/nagios/nrpe.d/nrpe_command.cfg'],
      notify  => Service['nagios-nrpe-server'],
    }
  }
  file_line { "check_cpu_${hostname}":
    ensure  => present,
    path    => '/etc/nagios/nrpe.d/nrpe_command.cfg',
    line    => 'command[check_cpu]=/usr/lib/nagios/plugins/check_cpu.sh -w 90 -c 95',
    require => File['/etc/nagios/nrpe.d/nrpe_command.cfg'],
    notify  => Service['nagios-nrpe-server'],
  }
  file_line { "check_vm_states_${hostname}":
    ensure  => present,
    path    => '/etc/nagios/nrpe.d/nrpe_command.cfg',
    line    => "command[check_vm_states]=${sudo_path} /usr/lib/nagios/plugins/privileged/check_vm_states.sh -s critical",
    require => File['/etc/nagios/nrpe.d/nrpe_command.cfg'],
    notify  => Service['nagios-nrpe-server'],
  }
}
