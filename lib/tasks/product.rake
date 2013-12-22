task :create_products => :environment do
  require 'nokogiri'
  require 'open-uri'
  require 'progressbar'
  links = []
  url = "http://www.prodirectsoccer.com/lists/football-boots.aspx?listName=football-boots&brand=Nike_adidas&t=Turf+Trainer_Soft+Ground_Indoor_Hard+Ground_Firm+Ground_Artificial+Grass_All+Ground&p=all"
  doc = Nokogiri::HTML(open(url))

  doc.css(".list_productentity").each do |entity|
    link = entity.at_css("a")['href']
    links << "http://www.prodirectsoccer.com#{link}"
    links
  end

  puts links.count
  # def download(url, output_file)
  #   exit unless system("wget -c #{url} -O #{output_file}")
  # end  

  pbar = ProgressBar.new("Product", doc.css(".list_productentity").count)
  links.each do |link|
    #download "#{link}", "lib/assets/#{id}.html"
    doc = Nokogiri::HTML(open(link))
    name = doc.at_css("#ProdSeoText h1").text[/(nike|adidas)?\W*(.*)/i, 2]
    if doc.at_css("#ProdPriceText p").nil?
      price = doc.at_css("#ProdPriceText h1").text[/[0-9\.]+/].to_f.round(2)
    else
      price = doc.at_css("#ProdPriceText p").text[/[0-9\.]+/].to_f.round(2)
    end   
    case doc.at_css(".SEOPanel").text
    when /Firm Ground|FG/
      type = 'Firm Ground'
    when /Indoor|TopSala|SuperSala|Elastico|Gato/
      type = 'Indoor'
    when /Turf|Trainer|adidas Freefootball x-ite Boots/
      type = 'Turf'
    when /Soft Ground|SG/
      type = 'Soft Ground'
    when /Hard Ground|HG/
      type = 'Hard Ground'
    when /Artificial Grass|AG/
      type = 'Artificial Grass'
    else
      type = 'unknown'
    end
    case doc.at_css(".SEOPanel").text
    when /adidas/i
      brand = 'adidas'
    when /nike/i
      brand = 'Nike'
    else
      brand = 'unknown'
    end
    puts "#{name} - #{link}"
    Product.where(name: name).first_or_create(price: price, brand_id: Brand.find_by_name(brand).id, type_id: Type.find_by_name(type).id, link: link).update_attributes(type_id: Type.find_by_name(type).id, brand_id: Brand.find_by_name(brand).id,link: link)
    pbar.inc
  end
end


task :update_available_sizes => :environment do
  require 'nokogiri'
  require 'open-uri'
  require 'database_cleaner'
  require 'progressbar'
  DatabaseCleaner.clean_with(:truncation, :only => %w[available_sizes])
  pbar = ProgressBar.new("Product", Product.all.count)
  Product.all.each do |product|
    doc = Nokogiri::HTML(open(product.link))
    doc.css(".dlw100_ProdControl1_SizeInStock").each do |size|
      AvailableSize.create(product_id: product.id, size_id: Size.find_by_number(size.text.gsub(/½/, '.5').to_d).id)
    end
    pbar.inc
  end
end


task :initiate_model => :environment do
  require 'database_cleaner'
  DatabaseCleaner.clean_with(:truncation, :only => %w[types brands sizes products])
  types = ['Firm Ground', 'Indoor', 'Turf', 'Soft Ground', 'Hard Ground', 'Artificial Grass', 'unknown']
  brands = ['adidas', 'Nike']
  sizes = (3..15).step(0.5).to_a
  types.each {|t| Type.create(name: t) }
  brands.each {|b| Brand.create(name: b) }
  sizes.each {|s| Size.create(number: s) }
end

task :download_images => :environment do
  
end