require 'open-uri'
require 'pry'

class Scraper

  # Collects :name, :location, and :profile_url for all students.
  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    # :profile_url = doc.css(".student-card a")[0]['href']
    # :name = doc.css(".student-card .card-text-container .student-name")[0].text
    # :location = doc.css(".student-card .card-text-container .student-location")[0].text
    students = []
    doc.css(".student-card").each do |student|
      students << {
        name: student.css(".card-text-container .student-name").text,
        location: student.css(".card-text-container .student-location").text,
        profile_url: student.css('a').attribute('href').value
      }
    end
    students
  end

  # Collects :linkedin, :github, :twitter, :blog, :profile_quote and :bio for a specific student.
  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    # websites = doc.css(".main-wrapper.profile .vitals-container .social-icon-container a").attribute('href').value
    # :profile_quote = doc.css(".main-wrapper.profile .vitals-text-container .profile-quote").text
    # :bio = doc.css(".main-wrapper.profile .details-container .bio-block.details-block .description-holder p").text
    profile = {
      profile_quote: doc.css(".main-wrapper.profile .vitals-text-container .profile-quote").text,
      bio: doc.css(".main-wrapper.profile .details-container .bio-block.details-block .description-holder p").text
    }
    soc_media = doc.css(".main-wrapper.profile .vitals-container .social-icon-container a").map { |website| website.attribute('href').value }
    soc_media.each do |website|
      case
        when website.include?("twitter")
          profile[:twitter] = website
        when website.include?("github")
          profile[:github] = website
        when website.include?("linkedin")
          profile[:linkedin] = website
        else
          profile[:blog] = website
      end
    end
    profile
  end

end
