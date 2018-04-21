FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "dummyemail#{n}@gmail.com"
    end
    password "dummypassword"
    password_confirmation "dummypassword"
  end
end
