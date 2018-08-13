require 'tag_fetcher'

class TagsController < ApplicationController
  def show
    fetcher = TagFetcher.new(params[:tag])
    tag = fetcher.fetch
    if tag
      Rails.logger.info "Tag #{tag.tag} from #{fetcher.from}"
      filtered_quotes = filter_quotes_attributes(tag.quotes)
      render json: {quotes: filtered_quotes}, status: 200
    else
      render nothing: true, status: 404
    end
  rescue => e
    Rails.logger.error(e)
    Rails.logger.error(e.backtrace.join('\n'))
    render json: { error: e }, status: 400
  end

  private

  def filter_quotes_attributes(quotes)
    quotes.map do |q|
      {
        text: q.text,
        author: q.author,
        author_about: q.author_about,
        tags: q.tags
      }
    end
  end
end
