FactoryBot.define do
  factory :product do
    title { "MyString" }
    price { "9.99" }
    published { false }
    user
  end
end
