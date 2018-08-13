require 'rails_helper'
require 'quote_scraper'

describe QuoteScraper do
  let!(:page) do
    file_fixture('quote_thinking.html').read
  end

  let!(:tag) { 'thinking' }

  before :each do
    uri_template = Addressable::Template.new "http://quotes.toscrape.com/tag/{tag}"
    stub_request(:get, uri_template)
      .to_return(body: page)
  end

  it 'should have 2 quotes' do
    scraper = QuoteScraper.new(tag)
    scraper.fetch_and_scrape
    expect(scraper.quotes.count).to eq 2
  end

  it 'should return nil when timeout' do
    uri_template = Addressable::Template.new "http://quotes.toscrape.com/tag/{tag}"
    stub_request(:get, uri_template).to_timeout

    scraper = QuoteScraper.new tag
    quotes = scraper.fetch_and_scrape
    expect(quotes).to be_nil
  end

  describe 'quote attributes' do
    let!(:quote) do
      scraper = QuoteScraper.new tag
      scraper.fetch_and_scrape
      scraper.quotes.first
    end

    it 'should have a text' do
      expected_text = "“The world as we have created it is a process of our thinking. It cannot be changed without changing our thinking.”"
      expect(quote[:text]).to eq expected_text
    end

    it 'should have an author' do
      expected_author = "Albert Einstein"
      expect(quote[:author]).to eq expected_author
    end

    it 'should have an author about link' do
      expected_author_link = "http://quotes.toscrape.com/author/Albert-Einstein"
      expect(quote[:author_about]).to eq expected_author_link
    end

    it 'should have 4 tags' do
      expect(quote[:tags].count).to eq 4
    end
  end
end
