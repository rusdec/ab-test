# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

def create_appbooster_data
  puts "Creating experiments..."

  Experiment.create(
    title: 'Цвет кнопки',
    key: 'button_color',
    options: {
      '#FF0000' => 33.3,
      '#00FF00' => 33.3,
      '#0000FF' => 33.3
    }
  )

  Experiment.create(
    title: 'Стоимость покупки',
    key: 'price',
    options: {
      '10' => 75,
      '20' => 10,
      '50' => 5,
      '5'  => 10
    },
  )

  puts "Expeiments count: #{Experiment.count}"
end

def create_experiments(count)
  count = 6000 if count > 6000
  experiments = []

  puts "Creating #{count} experiments..."
  count.times do |n|
    options = random_options(n)

    experiments << {
      title: "Эксперимент-#{n}",
      key: "key-#{n}",
      options: options.to_json,
      probability_line: set_probability_line(options).to_json,
      distribution_type: set_distribution_type(options),
      created_at: Time.now,
      updated_at: Time.now
    }
  end

  Experiment.multi_insert(experiments)

  puts "Expeiments: #{Experiment.count}"
end

def random_options(n)
  [
    { "value-i#{n}": 44,   "value-j#{n}": 55,   "value-l#{n}": 1 },
    { "value-a#{n}": 10,   "value-b#{n}": 60,   "value-c#{n}": 30 },
    { "value-i#{n}": 33.3, "value-j#{n}": 33.3, "value-l#{n}": 33.3 },
    { "value-d#{n}": 75,   "value-e#{n}": 10,   "value-g#{n}": 10, "value-h#{n}": 5 },
  ].sample
end

def set_distribution_type(options)
  uniform_difference = 1
  min, max = options.values.minmax
  
  enum = { percentage: 0, uniform: 1 }

  (max - min) <= uniform_difference ? enum[:uniform] : enum[:percentage]
end

def set_probability_line(options)
  probability_line = options.values

  probability_line.each_index do |index|
    probability_line[index] += probability_line[index - 1] if index > 0
  end

  probability_line
end

def add_device_tokens_to_experiments(count)
  puts "Adding #{count} devices to experiments..."

  count.times do |n|
    AddDeviceToExperiments.call(token: "token-#{n}")
  end

  puts "Devices: #{DeviceToken.count}"
  puts "DeviceExperimentValues: #{DistributedOption.count}"
end

# create_experiments(1000)
# add_device_tokens_to_experiments(100)

create_appbooster_data
