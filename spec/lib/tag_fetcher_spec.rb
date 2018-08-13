require 'rails_helper'
require 'tag_fetcher'

describe TagFetcher do
  let!(:tag_for_search) { 'thinking' }

  describe 'fetch' do
    it 'should find in the db' do
      fetcher = TagFetcher.new tag_for_search
      expect(fetcher)
        .to receive(:fetch_from_db)
        .at_least(:once)
        .and_return(build(:tag))
      expect(fetcher).not_to receive(:fetch_from_web)
      fetcher.fetch
    end

    it 'should find in the web' do
      fetcher = TagFetcher.new tag_for_search
      expect(fetcher)
        .to receive(:fetch_from_db)
        .and_return(nil)
      expect(fetcher).to receive(:fetch_from_web)
      fetcher.fetch
    end
  end

  describe 'fetch from db' do
    it 'should find the tag in the db' do
      tag = create :tag
      fetcher = TagFetcher.new tag_for_search
      fetcher.fetch_from_db
      expect(fetcher.tag).to eq tag
      expect(fetcher.from).to eq :db
    end

    it 'should not find the tag in the db' do
      fetcher = TagFetcher.new tag_for_search
      fetcher.fetch_from_db
      expect(fetcher.tag).to be_nil
    end
  end

  describe 'fetch from web' do
    before :each do
      page = file_fixture('quote_thinking.html').read
      uri_template = Addressable::Template.new "http://quotes.toscrape.com/tag/{tag}"
      stub_request(:get, uri_template)
        .to_return(body: page)
    end
    it 'should find the tag on the web' do

      fetcher = TagFetcher.new tag_for_search
      fetcher.fetch_from_web
      expect(fetcher.tag).not_to be_nil
      expect(fetcher.from).to eq :web
    end

    it 'should save a new tag' do
      fetcher = TagFetcher.new tag_for_search
      expect{fetcher.fetch_from_web}
        .to change{Tag.count}.by(1)
    end

    it 'should raise an FailedToFetchError' do
      qs = double "quote_scraper"
      expect(qs)
        .to receive(:fetch_and_scrape)
        .and_return(nil)
      expect(QuoteScraper)
        .to receive(:new)
        .and_return(qs)

      fetcher = TagFetcher.new tag_for_search
      expect{fetcher.fetch}.to raise_error(TagFetcher::FailedToFetchError)
    end
  end
end
