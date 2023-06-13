class Experiment < Sequel::Model
  plugin :validation_helpers
  plugin :association_dependencies
  plugin :timestamps, update_on_create: true
  plugin :enum

  enum :distribution_type, percentage: 0, uniform: 1

  one_to_many :distributed_options
  add_association_dependencies distributed_options: :destroy

  def before_save
    super

    set_distribution_type
    set_probability_line
  end

  def after_save
    super

    ValueDistributor.refresh_uniform_cache
  end

  def validate
    super

    validates_presence [:title, :key, :options]
    validates_min_length 1, [:title, :key]
    validates_max_length 100, :key
    validates_max_length 250, :title

    validates_options
  end

  private

  def set_distribution_type
    if options.size == 1
      self.distribution_type = :percentage
    else
      uniform_difference = 1
      min, max = options.values.minmax

      self.distribution_type = (max - min) <= uniform_difference ? :uniform : :percentage
    end
  end

  def set_probability_line
    self.probability_line = options.values

    probability_line.each_index do |index|
      probability_line[index] += probability_line[index - 1] if index > 0
    end
  end

  def validates_options
    return unless validates_options_type

    validates_options_value_length
    validates_probabilities_sum
  end

  def validates_options_type
    return true if options.is_a?(Sequel::Postgres::JSONHash)

    errors.add(:options, 'should be a hash')

    false
  end

  def validates_options_value_length
    return true if options.keys.all? { _1.length <= 100 }

    errors.add(:option, 'values length should be less than 100')

    false
  end

  def validates_probabilities_sum
    sum = options.values.sum(&:to_d)

    return true if sum >= 99.9.to_d && sum <= 100

    errors.add(:options, 'sum of probabilities is equal 99.9% or 100%')

    false
  end
end
