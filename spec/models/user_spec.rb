require 'rails_helper'

RSpec.describe User, type: :model do
  it {is_expected.to be_mongoid_document}

  it {is_expected.to have_field(:email)
    .of_type(String).with_default_value_of('')}
  it {is_expected.to have_field(:encrypted_password)
    .of_type(String).with_default_value_of('')}

  it {is_expected.to have_field(:reset_password_token)
    .of_type(String)}
  it {is_expected.to have_field(:reset_password_sent_at)
    .of_type(Time)}

  it {is_expected.to have_field(:sign_in_count)
    .of_type(Integer).with_default_value_of(0)}
  it {is_expected.to have_field(:current_sign_in_at)
    .of_type(Time)}
  it {is_expected.to have_field(:last_sign_in_at)
    .of_type(Time)}
  it {is_expected.to have_field(:current_sign_in_ip)
    .of_type(String)}
  it {is_expected.to have_field(:last_sign_in_ip)
    .of_type(String)}

  it {is_expected.to have_field(:jti).of_type(String)}

  it {validate_uniqueness_of([:jti, :email])}

  describe '::primary_key' do
    it {expect(User.primary_key).to eq '_id'}
  end

  describe '::revoke_jwt' do
    let!(:user) { create :user }

    it 'should update user jti' do
      old_jti = user.jti
      User.revoke_jwt(nil, user)
      expect(user.jti).not_to eq old_jti
    end
  end
end
