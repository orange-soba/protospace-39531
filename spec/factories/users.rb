FactoryBot.define do
  factory :user do
    email                 {Faker::Internet.email}
    password              {Faker::Internet.password(min_length: 6)}
    password_confirmation {password}
    name                  {Faker::Name.first_name}
    profile               {Faker::Lorem.sentence}
    occupation            {Faker::Company.department}
    position              {Faker::Job.position}
  end
end
