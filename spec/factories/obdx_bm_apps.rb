FactoryGirl.define do
  sequence(:app_id) {|n| "%010i" % "#{n}" }
  factory :bm_app do
    app_id 
    channel_id "1239481723"
    needs_otp "N"
    approval_status "U"
  end
end