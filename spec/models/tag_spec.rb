require 'rails_helper'

describe Tag, type: :model do
  it {is_expected.to be_mongoid_document}

  it {is_expected.to have_field(:tag).of_type(String)}
  it {validate_presence_of(:tag)}
  it {validate_uniqueness_of(:tag)}
  
  it {is_expected.to embed_many(:quotes)}
end
