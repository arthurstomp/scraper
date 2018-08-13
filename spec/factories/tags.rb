FactoryBot.define do
  factory :tag do
    tag 'thinking'
    factory :tag_with_quotes do
      transient do
        quotes_count 2
      end

      after(:build) do |tag, evaluator|
        build_list(:quote, evaluator.quotes_count, tag: tag)
      end
    end
  end
end
