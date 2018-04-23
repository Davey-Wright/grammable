FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "dummyemail#{n}@gmail.com"
    end
    password "dummypassword"
    password_confirmation "dummypassword"
  end

  factory :gram do
    message 'This is a dummy message'
    photo { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'hanger.jpg').to_s, 'image/jpeg') }
    association :user
  end
end
