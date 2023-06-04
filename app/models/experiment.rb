class Experiment < ApplicationRecord
  has_many :device_experiment_values, dependent: :destroy

  validates :title, presence: true, length: { minimum: 1, maximum: 250 }
  validates :description, allow_nil: true, length: { maximum: 1000 }
  validates :key, presence: true, length: { minimum: 1, maximum: 250 }
end
