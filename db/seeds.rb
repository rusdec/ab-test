# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

def create_appbooster_data
 Experiment.create!([
   {
     title: 'Цвет кнопки',
     description: 'У нас есть гипотеза, что цвет кнопки «купить» влияет на конверсию в покупку',
     key: 'button_color',
     options: {
       '#FF0000' => 33.3,
       '#00FF00' => 33.3,
       '#0000FF' => 33.3
     }
   },
   {
     title: 'Стоимость покупки',
     description: 'У нас есть гипотеза, что изменение стоимости покупки в приложении может повлять на нашу маржинальную прибыль',
     key: 'price',
     options: {
       '10' => 75,
       '20' => 10,
       '50' => 5,
       '5'  => 10
     }
   }
 ])
end

def create_experiments(count)
  count = 3000 if count > 3000
  experiments = []
  random_options = ->(n) do
    [
      {
        "value-a#{n}": 10,
        "value-b#{n}": 60,
        "value-c#{n}": 30
      },
      {
        "value-d#{n}": 75,
        "value-e#{n}": 10,
        "value-g#{n}": 10,
        "value-h#{n}": 5
      },
      {
        "value-i#{n}": 44,
        "value-j#{n}": 55,
        "value-l#{n}": 1,
      }
    ].sample
  end

  puts "Creating #{count} experiments..."

  count.times do |n|
    experiments << {
      title: "Эксперимент-#{n}",
      description: nil,
      key: "key-#{n}",
      options: random_options[n]
    }
  end

  Experiment.insert_all(experiments)

  puts "Expeiments: #{Experiment.count}"
end

def add_device_tokens_to_experiments(count)
  puts "Adding #{count} devices to experiments..."

  count.times do |n|
    AddDeviceToExperiments.call(token: "token-#{n}")
  end

  puts "Devices: #{DeviceToken.count}"
  puts "DeviceExperimentValues: #{DeviceExperimentValue.count}"
end

#create_experiments(1500)
#add_device_tokens_to_experiments(800)

create_appbooster_data
