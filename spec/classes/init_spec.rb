require 'spec_helper'
describe 'nagioscompute' do

  context 'with defaults for all parameters' do
    it { should contain_class('nagioscompute') }
  end
end
