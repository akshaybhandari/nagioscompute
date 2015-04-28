class nagioscompute::setup::services (
  $service_list = ['openvswitch-switch', 'nova-compute', 'libvirt-bin'],
) {
  #OpenStack related checks
  each($service_list) |$service| {
    @@nagios_service { "check_service_${service}_${hostname}":
      check_command       => "check_nrpe_1arg!check_service_${service}",
      use                 => "generic-service",
      host_name           => "$fqdn",
      service_description => "check_service_${service}",
    }
  }
  @@nagios_service { "check_cpu_${hostname}":
    check_command       => "check_nrpe_1arg!check_cpu",
    use                 => "generic-service",
    host_name           => "$fqdn",
    service_description => "CPU",
  }
  @@nagios_service { "check_vm_states_${hostname}":
    check_command       => "check_nrpe_1arg!check_vm_states",
    use                 => "generic-service",
    host_name           => "$fqdn",
    service_description => "VM_states",
  }
}
