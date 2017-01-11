require "spec_helper"

RSpec.describe RickRollout::Feature.new({}) do

  before(:all) do
    RickRollout.configure do |config|
      rollout = Rollout.new(Redis.new(port: 16379))

      config.rollout = rollout
    end
  end

  describe '.active? with rollout.active? returning false' do
    it 'returns false if feature flags are enabled' do
      allow(ENV).to receive(:fetch) { '1' }
      expect(subject.active?({})).to be_falsey
    end

    it 'returns true if feature flags are disabled' do
      allow(ENV).to receive(:fetch) { '0' }
      expect(subject.active?({})).to be_truthy
    end
  end

  describe '.active? with rollout.active? returning true' do
    it 'returns true if rollout is active and feature flags are disabled' do
      allow(RickRollout.configuration.rollout).to receive(:active?) { true }
      allow(ENV).to receive(:fetch) { '0' }
      expect(subject.active?({})).to be_truthy
    end

    it 'returns true if rollout is active feature flags are enabled' do
      allow(RickRollout.configuration.rollout).to receive(:active?) { true }
      allow(ENV).to receive(:fetch) { '1' }
      expect(subject.active?({})).to be_truthy
    end
  end
end
