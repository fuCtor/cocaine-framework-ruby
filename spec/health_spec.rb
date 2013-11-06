require 'rspec'

require_relative '../lib/cocaine/health'

describe Cocaine::HealthManager do
  it 'should be' do
    d = double()
    Cocaine::HealthManager.new d
  end

  it 'should stop event loop if nobody takes breath to it until timeout' do
    EM.run do
      d = double()
      d.should_receive(:send_heartbeat).with(0).at_least(:once)
      health = Cocaine::HealthManager.new d, disown: 0.0, heartbeat: 0
      health.start()
    end
  end
end