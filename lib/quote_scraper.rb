require 'open-uri'

class QuoteScraper
  @@base_uri = 'http://quotes.toscrape.com'

  attr_reader :doc, :tag, :quotes
  def initialize(tag)
    @tag = tag
    fetch
    parse_quotes
  end

  private

  def fetch
    uri = @@base_uri + "/tag/#{@tag}"
    @doc = Nokogiri::HTML(open(uri))
  end

  def parse_quotes
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
