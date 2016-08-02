# -*- coding: utf-8 -*-
require 'open-uri'
require 'nokogiri'
require 'uri'

search_word = URI.escape("クローラー")
url = "http://www.amazon.co.jp/s/ref=nb_sb_noss_2?__mk_ja_JP=%E3%82%AB%E3%82%BF%E3%82%AB%E3%83%8A&url=search-alias%3Daps&field-keywords=#{search_word}"
# url= "http://www.amazon.co.jp/s/ref=nb_sb_noss?url=search-alias%3Dstripbooks&field-keywords=#{search_word}"
doc = Nokogiri::HTML(open(url))
doc.xpath("//h3[@class='newaps']/a").each {|item|
	# ASIN
	puts item[:href].match(%r{dp/(.+)})[1]
}
