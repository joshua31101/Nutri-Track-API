class IngredientScraper < ActiveJob::Base
  def perform
    require 'open-uri'
    require 'nokogiri'
    require 'json'

    url = 'http://www.befoodsmart.com/alphabetical-ingredient-listing.php'
    doc = Nokogiri::HTML(open(url))
    links = doc.css('a.bfslink').map { |a| a['href'] }
    link_count = links.count - 3
    puts '*********** Scraping ***********'
    (0..link_count).each do |i|
      begin
        d = Nokogiri::HTML(open('http://www.befoodsmart.com/' + links[i]))
      rescue OpenURI::HTTPError => err
        puts 'an error occurred while opening the webpage'
        next
      end
      info = d.css('.results-categories2 + p')
      name = d.css('.ing-title').text.strip
      alt_names = ''
      desc = ''
      additional_info = ''
      found_in = ''
      possible_health_effects = ''
      allergy = ''

      d.css('.results-categories2').each_with_index do |result, index|
        text = result ? result.text : ''
        if text.include? 'Alternate'
          alt_names = info[index].text.strip
        elsif text.include? 'Desc'
          desc = info[index].text.strip
        elsif text.include? 'Additional'
          additional_info = info[index].text.strip
        elsif text.include? 'Found'
          found_in = info[index].text.strip
        elsif text.include? 'Possible'
          possible_health_effects = info[index].text.strip
        elsif text.include? 'Allergy'
          allergy = info[index].text.strip
        end
      end

      puts name

      Ingredient.create(
        name: name,
        alt_names: alt_names,
        desc: desc,
        additional_info: additional_info,
        found_in: found_in,
        possible_health_effects: possible_health_effects,
        allergy: allergy
      )
    end
    puts '*********** Finished ***********'
  end
end
