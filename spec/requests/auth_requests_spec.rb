require 'rails_helper'
require 'json'

describe 'Auth requests', type: :request do
  let(:headers) do
    {
      "CONTENT_TYPE" => "application/json"
    }
  end
  let(:user_attrs) do
    {
        email: 'test@test.com',
        password: '12341234'
    }
  end

  let(:new_user_attrs) {
    {
        email: 'test2@test.com',
        password: '12341234'
    }
  }

  let(:json_user) do
    {
      user: user_attrs
    }.to_json
  end

  let!(:json_new_user) do
    {
      user: new_user_attrs  
    }.to_json
  end

  before :each do
    User.create(user_attrs)
  end

  it 'creates user' do
    post '/users',
      params: json_new_user,
      headers: headers

    expect(response.status).to eq 201
    expect(response.headers['Authorization']).not_to be_nil
  end

  it 'sign in user' do
    post '/users/sign_in',
      params: json_user,
      headers: headers

    expect(response.status).to eq 201
    expect(response.headers['Authorization']).not_to be_nil
  end

  it 'sign out user and revoke jwt' do
    # sign in first
    post '/users/sign_in',
      params: json_user,
      headers: headers


    h = response.headers
    u = JSON.parse(response.body)

    headers['Authorization'] = h['Authorization']
    delete '/users/sign_out',
      headers: headers

    user = User.find_by(email: u['email'])
    expect(user.jti).not_to eq u['jti']
  end
end
