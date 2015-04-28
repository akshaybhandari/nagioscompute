class nagioscompute::setup {
  class { 'nagioscompute::setup::services':
    service_list          => $::nagioscompute::service_list,
  } ->
  class { 'nagioscompute::setup::files': } ->
  class { 'nagioscompute::setup::commands':
    service_list          => $::nagioscompute::service_list,
  }
}
