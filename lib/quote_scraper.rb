require 'open-uri'

# class QuoteScraper
# Get the page from the web and scrape quotes from it.
class QuoteScraper
  @@base_uri = 'http://quotes.toscrape.com'

  attr_reader :doc, :tag, :quotes
  def initialize(tag)
    @tag = tag
  end

  def fetch_and_scrape
    doc = fetch
    if(doc)
      scrape_quotes(doc)
    end
  end

  private

  def fetch
    uri = @@base_uri + "/tag/#{@tag}"
    @doc = Nokogiri::HTML(open(uri))
  rescue StandardError => e
    Rails.logger.error("QuoteScraper: #{e}")
    Rails.logger.error e.backtrace.join('\n')
    nil
  end

  def scrape_quotes(doc)
    @quotes = doc.search('.quote').map do |q|
      {
        text: parse_text(q),
        author: parse_author(q),
        author_about: parse_author_about(q),
        tags: parse_tags(q)
      }
    end
  end

  def parse_text(q)
    q.search('.text').first.text
  end

  def parse_author(q)
    q.search('.author').first.text
  end
  
  def parse_author_about(q)
    path = q.search('span')[1]
      .search('a').first
      .attributes['href'].value
    @@base_uri + path
  end

  def parse_tags(q)
    q.search('.keywords').first
      .attributes['content'].value.split(',')
  end
end
