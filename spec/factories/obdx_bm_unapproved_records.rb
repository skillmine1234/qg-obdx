# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :bm_unapproved_record do
    bm_approvable_id 1
    bm_approvable_type "MyString"
  end
end
