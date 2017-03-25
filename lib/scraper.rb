require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    page = Nokogiri::HTML(open(index_url))
    students = page.css('.student-card')
    students.map do |student|
      { profile_url: "#{index_url[0..-11]}#{student.css('a').attribute('href').value}",
        location: student.css('.student-location').text,
        name: student.css('.student-name').text
      }
    end
  end

  def self.scrape_profile_page(profile_url)
    page = Nokogiri::HTML(open(profile_url))
    social_links = page.css('.social-icon-container a')
    profile_quote = page.css('.profile-quote').text
    bio = page.css('.bio-block p').text
    profile_info = social_links.each_with_object({}) do |link, hash|
      url = link.attribute('href').value
      case url
      when /twitter/
        hash[:twitter] = url
      when /github/
        hash[:github] = url
      when /linkedin/
        hash[:linkedin] = url
      else
        hash[:blog] = url
      end
    end
    profile_info[:bio] = bio
    profile_info[:profile_quote] = profile_quote
    profile_info
  end
end
