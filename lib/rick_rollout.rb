require "rick_rollout/version"

module RickRollout
  class Feature
    attr_reader :user

    def initialize(user)
      @user = user
    end

    def active?(*args)
      feature_flags_disabled? || $rollout.active?(*args)
    end

    def activate_group(*args)
      $rollout.activate_group(*args)
    end

    private

    def feature_flags_disabled?
      ENV.fetch('FEATURE_FLAGS', '1').to_i.zero?
    end
  end
end
