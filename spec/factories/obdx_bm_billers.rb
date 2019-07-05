
FactoryGirl.define do
  factory :bm_biller do
    biller_code "MyString"
    biller_name "MyString"
    biller_category "MyStirng"
    biller_location "MyString"
    processing_method "MyString"
    is_enabled "N"
    num_params 0
    approval_status "U"
  end
end