# app/controllers/pages_controller.rb
require 'mechanize'
require 'iso-639'

class PagesController < ApplicationController
    def index
      wikipedia_link = params[:wikipedia_link]
  
      if wikipedia_link.present? && valid_wikipedia_url?(wikipedia_link)
        @article_data = scrape_wikipedia_data(wikipedia_link)
      end
    end
  
    private
  
    def valid_wikipedia_url?(url)
      url.start_with?('https://en.wikipedia.org/wiki/')
    end
  
    def scrape_wikipedia_data(url)
        agent = Mechanize.new
        
        language_links = [
            { 'lang' => 'en' },
            { 'lang' => 'fr' },
          ]
        long_names = language_links.map { |link| ISO_639.find(link['lang']).english_name }
        article_title = url.split('/').last
        page = agent.get(url)
        language_links = page.search('.interlanguage-link-target')
        
        languages = language_links.map { |link| link['lang'] }

        languages_in_full = []
        
        languages.map do |language|
            long_name=  ISO_639.find(language) 
            languages_in_full.push(long_name)
        end

      { title: article_title.gsub('_', ' '), languages: languages_in_full }
    end
  end
  