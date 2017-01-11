require "rick_rollout/version"

module RickRollout

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new

    yield configuration
  end

  class Configuration
    attr_accessor :rollout
  end

  class Feature
    attr_reader :user

    def initialize(user)
      @user = user
    end

    def active?(*args)
      feature_flags_disabled? || RickRollout.configuration.rollout.active?(*args)
    end

    def activate_group(*args)
      RickRollout.configuration.rollout.activate_group(*args)
    end

    private

    def feature_flags_disabled?
      ENV.fetch('FEATURE_FLAGS', '1').to_i.zero?
    end
  end
end
