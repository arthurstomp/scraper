require 'quote_scraper'

# class TagFetcher
#  
# Responsible for controlling from where the tag will come from,
# from the database or from the web (and later pesisted in the db).
class TagFetcher
  attr_reader :tag, :from, :tag_to_search

  def initialize(tag_to_search)
    @tag_to_search = tag_to_search
  end

  def fetch
    if fetch_from_db
      fetch_from_db
    else
      fetch_from_web
    end
  end

  def fetch_from_db
    return tag if tag
    tag_from_db = Tag.find_by(tag: tag_to_search)
    if tag_from_db
      @from = :db
      @tag = tag_from_db
    end
  end

  def fetch_from_web
    quotes_from_tag = QuoteScraper.new(tag_to_search).fetch_and_scrape
    if(quotes_from_tag)
      tag_attrs = {
        tag: tag_to_search,
        quotes: quotes_from_tag
      }
      @from = :web
      @tag = Tag.create(tag_attrs)
    else
      raise FailedToFetchError, "failed to fetch tag: #{@tag_to_search}"
    end
  end
end

class TagFetcher::FailedToFetchError < StandardError
end
