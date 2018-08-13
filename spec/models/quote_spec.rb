require 'rails_helper'

describe Quote, type: :model do
  it {is_expected.to be_mongoid_document}

  it {is_expected.to have_field(:text).of_type(String)}
  it {is_expected.to have_field(:author).of_type(String)}
  it {is_expected.to have_field(:author_about).of_type(String)}
  it {is_expected.to have_field(:tags).of_type(Array)}

  it {validate_presence_of([:text, :author, :author_about])}

  it {is_expected.to be_embedded_in :tag}
end
