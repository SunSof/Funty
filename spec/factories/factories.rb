require 'faker'

FactoryBot.define do
  factory :user do
    name { 'Софья' }
    email { 'buketovasofi@gmail.com' }
    password { '123456789' }
    password_confirmation { '123456789' }
    token { 1_122_334_455 }
  end
end
