FactoryBot.define do
  factory :prototype do
    title      {Faker::Lorem.word}
    catch_copy {Faker::Company.catch_phrase}
    concept    {Faker::Lorem.sentence}

    association :user

    after(:build) do |prototype|
      prototype.image.attach(io: File.open("public/images/test_image.png"), filename: "test_image.png")
    end
  end
end
