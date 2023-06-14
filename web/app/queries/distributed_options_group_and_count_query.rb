# frozen_string_literal: true

class DistributedOptionsGroupAndCountQuery
  # @param [Sequel::Postgres::Dataset] experiments
  def initialize(experiments)
    @experiments = experiments
  end

  # @return [Sequel::Postgres::Dataset]
  def call
    DistributedOption
      .group_and_count(:experiment_id, :value)
      .where(experiment_id: @experiments.select(:id))
  end
end
