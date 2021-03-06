FactoryBot.define do
  factory :quote do
    text '“The world as we have created it is a process of our thinking. It cannot be changed without changing our thinking.”'
    author 'Albert Einstein'
    author_about 'http://quotes.toscrape.com/author/Albert-Einstein'
    tags ['change', 'deep-thoughts', 'thinking', 'world']
  end
end
