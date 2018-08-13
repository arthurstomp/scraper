require 'rails_helper'
require 'json'

describe 'Tag requests', type: :request do
  let!(:tag_text) { 'thinking' }
  let(:headers) do
    {
      "CONTENT_TYPE" => "application/json"
    }
  end

  let!(:user) { create(:user) }
  let!(:tag) { create(:tag_with_quotes, tag: tag_text) }

  before :each do
    params = {
      user: {
        email: user.email,
        password: user.password
      }
    }.to_json

    post '/users/sign_in',
      params: params,
      headers: headers

    headers["Authorization"] = response.headers["Authorization"]
  end

  describe 'GET /quotes/:tag' do
    it 'should return tag quotes' do
      get "/quotes/#{tag.tag}",
        headers: headers

      expect(response.status).to eq 200

      quotes = JSON.parse(response.body)['quotes']
      expect(quotes.count).to eq tag.quotes.count
    end

    it 'should not return to unauthorized request' do
      h = { "CONTENT_TYPE" => "application/json" }

      get "/quotes/#{tag.tag}",
        headers: h

        expect(response.status).to eq 401
    end

    describe 'response format' do
      before :each do
        get "/quotes/#{tag.tag}",
          headers: headers
      end
      let(:quotes) { JSON.parse(response.body)['quotes'] }
      it { expect(quotes).to be_an(Array) }

      describe 'each quote' do
        let(:quote_sample) { quotes[0] }
        it { expect(quote_sample['text']).to be_an(String) }
        it { expect(quote_sample['author']).to be_an(String) }
        it { expect(quote_sample['author_about']).to be_an(String) }
        it { expect(quote_sample['tags']).to be_an(Array) }
      end

    end

    describe 'fetching from the web' do
      let!(:page) { file_fixture('quote_thinking.html').read }
      let(:stubbed_request) do
        uri_template = Addressable::Template.new "http://quotes.toscrape.com/tag/{tag}"
        stub_request(:get, uri_template)
      end

      it 'should increase the number of tags' do
        stubbed_request.to_return(body: page)
        expect{
          get "/quotes/love",
            headers: headers
        }.to change{Tag.count}.by(1)

        expect(response.status).to eq 200
      end

      it 'fail to fetch quotes from web due timeout' do
        stubbed_request.to_timeout
        get "/quotes/love",
          headers: headers
        expect(response.status).to eq 400
        expect(response.body['error']).not_to be_nil
      end
    end
  end
end
