﻿# -*- coding: utf-8 -*-
require 'nokogiri'
require 'open-uri'

#
url = 'http://info.finance.yahoo.co.jp/fx/detail/?code=GBPUSD=FX'
doc = Nokogiri::HTML(open(url))
bid = doc.xpath("//*[@id='GBPUSD_detail_bid']").text
ask = doc.xpath("//*[@id='GBPUSD_detail_ask']").text
puts "Bid(売値)：#{bid}"
puts "Ask(買値)：#{ask}"

# ドル円
url = 'http://info.finance.yahoo.co.jp/fx/detail/?code=USDJPY=FX'
doc = Nokogiri::HTML(open(url))
bid = doc.xpath("//*[@id='USDJPY_detail_bid']").text
ask = doc.xpath("//*[@id='USDJPY_detail_ask']").text
puts "Bid(売値)：#{bid}"
puts "Ask(買値)：#{ask}"

