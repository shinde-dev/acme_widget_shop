FactoryBot.define do
  factory :delivery_rule do
    min_total { 0 }
    max_total { 50 }
    charge { 4.95 }
  end
end
