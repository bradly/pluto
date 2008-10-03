require 'rubygems'
require 'feed-normalizer'

class FeedNormalizer::Entry; attr_accessor :feed_title, :feed_url; end

class Aggregator
  attr_accessor :feed_urls, :entries
  
  def initialize( urls = [] )    
    self.feed_urls = urls    
    @entries       = []
    collect_entries
  end

  def collect_entries
    feed_urls.each do |feed_url|
      begin
        rss = FeedNormalizer::FeedNormalizer.parse open(feed_url)
        if not rss.entries.nil?
          rss.entries.each { |e| e.feed_title=rss.title; feed_url=rss.urls.first; }
          @entries.concat rss.entries
        end
      rescue
        # sliently recue from any tmieouts or 404 when hitting the feeds
      end
      
    end
    @entries.sort! { |a, b| b.date_published <=> a.date_published }
  end
end