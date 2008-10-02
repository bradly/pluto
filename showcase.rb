require 'rubygems'
require 'erubis'
require 'activesupport'

class Showcase
  
  attr_accessor :main_feed, :sidebar_feed, :max_per_page, :output_dir, :template

  def initialize( first_feed, second_feed, number_per_page = 15)
    @main_feed       = first_feed
    @sidebar_feed    = second_feed
    @max_per_page    = number_per_page
    @output_dir      = 'output'
    @template        = File.read('view/default.html.erb')
    @number_of_pages = (@main_feed.entries.length / @max_per_page.to_f).ceil
  end
  

  def render_output
    Dir.mkdir(@output_dir) unless File.exists?(@output_dir)
    
    page_counter = 1
    @main_feed.entries.in_groups_of(@max_per_page, false) do |page|
      open( "#{@output_dir}/#{file_name(page_counter)}", 'w' ) do |file|
        eruby = Erubis::Eruby.new(@template)
        file.write eruby.result({:main_entries => page, :sidebar_entries => @sidebar_feed.entries.slice(0,10), :pagination => pagination(page_counter)})
        file.close
      end
      page_counter += 1
    end
  end

  def pagination( current_page, markup = '' )
    (1 .. @number_of_pages).to_a.each do |n| 
      active_class = (n==current_page ? 'active' : '')
      markup += "<a href=\"#{file_name(n)}\" class=\"#{active_class}\">Page #{n}</a>"
    end
    return markup
  end
    
  def file_name(page_counter)
    "#{(page_counter==1 ? 'index' : "page_#{page_counter}")}.html"
  end
  
end