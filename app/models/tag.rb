class Tag
  include Mongoid::Document

  field :tag, type: String

  validates :tag, presence: true, uniqueness: true

  embeds_many :quotes, cascade_callbacks: true
end
