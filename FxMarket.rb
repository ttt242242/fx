# -*- coding: utf-8 -*-
require 'nokogiri'
require 'open-uri'
require 'yaml'

#
# 市場の2日おきに取引をした時の利益を記録しておく
# 状態は各為替にして、その時にどの程度変化するかを保存しておく
#


#  まず２日前の金額の呼び出し privous_money.yml
#  その日の為替を取得
#  差額を計算
#  差額に更新しておく 資源の期待値を更新しておく

class FxMarket
 
  def update
    #前日のデータの取得
    previous_datas = YAML.load_file("previous_data.yml") ;
    #その日の為替を取得
    today_datas = get_today_data();
    name_list = previous_datas.keys ;
    difference = {} ;
    #差額を計算
    name_list.each do |name|
      difference[name] = today_datas[name] - previous_datas[name] ;
    end
    #差額に更新しておく 資源の期待値を更新しておく

  end

end

url = 'http://info.finance.yahoo.co.jp/fx/detail/?code=GBPJPY=FX'
doc = Nokogiri::HTML(open(url))
bid = doc.xpath("//*[@id='GBPJPY_detail_bid']").text
ask = doc.xpath("//*[@id='GBPJPY_detail_ask']").text
puts "Bid(売値)：#{bid}"
puts "Ask(買値)：#{ask}"

# ドル円
url = 'http://info.finance.yahoo.co.jp/fx/detail/?code=USDJPY=FX'
doc = Nokogiri::HTML(open(url))
bid = doc.xpath("//*[@id='USDJPY_detail_bid']").text
ask = doc.xpath("//*[@id='USDJPY_detail_ask']").text
puts "Bid(売値)：#{bid}"
puts "Ask(買値)：#{ask}"

