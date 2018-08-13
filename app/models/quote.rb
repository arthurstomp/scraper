class Quote
  include Mongoid::Document

  field :text, type: String
  field :author, type: String
  field :author_about, type: String
  field :tags, type: Array

  validates_presence_of :text, :author, :author_about

  embedded_in :tag
end
