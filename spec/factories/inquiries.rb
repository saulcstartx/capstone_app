FactoryGirl.define do
  factory :inquiry do
    title { Faker::Lorem.sentence }
    question { "#{Faker::Lorem.paragraph}?" }
    customer_id 1

    trait :with_roles do
      after(:create) do |inquiry|
        Role.create(:role_name=>Role::ORGANIZER,
                    :mname=>Inquiry.name,
                    :mid=>inquiry.id,
                    :user_id=>inquiry.customer_id)
      end
    end
  end
end
