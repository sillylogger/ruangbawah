FactoryGirl.define do

  factory :user do
    email         "change@me-10100952355977829-facebook.com"
    password      "password"
    name          "Tommy Sullivan"
    avatar_url    "http://graph.facebook.com/10100952355977829/picture"

    confirmed_at { Time.zone.now }
  end

end
