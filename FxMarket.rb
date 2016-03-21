#!/usr/bin/ruby
# -*- encoding: utf-8 -*-

$LOAD_PATH.push(File::dirname($0)) ;
require 'nokogiri'
require 'open-uri'
require 'yaml'
require '/home/okano/fx/Link'
require '/home/okano/fx/Node'
require '/home/okano/fx/NN'
require '/home/okano/lab/oknLib/rubyOkn/BasicTool'
require 'clockwork'

#
# 市場の2日おきに取引をした時の利益を記録しておく
# 状態は各為替にして、その時にどの程度変化するかを保存しておく
#

include BasicTool
include Clockwork

#  まず２日前の金額の呼び出し privous_money.yml
#  その日の為替を取得
#  差額を計算
#  差額に更新しておく 資源の期待値を更新しておく

class FxMarket
 
  def update()
    #前日のデータの取得
    #その日の為替を取得
    # today_datas = get_today_data();

    system("ruby make_setting.rb") ;
    nn_conf = YAML.load_file("nn_setting.yml") ;
    nn = NN.new(nn_conf)



    previous_datas = YAML.load_file("fx_datas.yml") ;
    previous_datas = get_today_data();
    traning_data={:input => {0 => previous_datas[:GBPJPY][:ask].to_f,1 => previous_datas[:USDJPY][:ask].to_f},:output => {5 => previous_datas[:USDJPY][:bid].to_f}} ;
    nn.training_one_time(traning_data) ;
    traning_data[:output] = nn.nodes.last.get_w
    previous_datas.push(traning_data) ;
    make_yaml_file("fx_data.yml", previous_datas) ;
    # name_list = previous_datas.keys ;
    # difference = {} ;
    # #差額を計算
    # name_list.each do |name|
    #   difference[name] = today_datas[name] - previous_datas[name] ;
    # end
  end

  #
  # === 今日の為替のデータの取得
  # @return exchange hash 今日の為替情報を格納したデータ
  #
  def get_today_data()
    exchange = {} ; #為替を記録する
    exchange[:GBPJPY] = get_exchange_info("GBPJPY") ;
    exchange[:USDJPY] = get_exchange_info("USDJPY") ;

    return exchange ;
  end

  #
  #
  # @param name string 欲しい為替の情報　例:GBPJPY 
  # @return {:bid => bid, :ask => ask} hash 売値、買値
  #
  def get_exchange_info(name)
    url = "http://info.finance.yahoo.co.jp/fx/detail/?code=#{name}=FX"
    doc = Nokogiri::HTML(open(url))
    bid = doc.xpath("//*[@id='#{name}_detail_bid']").text
    ask = doc.xpath("//*[@id='#{name}_detail_ask']").text
    # puts "Bid(売値)：#{bid}"
    # puts "Ask(買値)：#{ask}"

    return {:bid => bid, :ask => ask} ;

  end 
end

# url = 'http://info.finance.yahoo.co.jp/fx/detail/?code=GBPJPY=FX'
# doc = Nokogiri::HTML(open(url))
# bid = doc.xpath("//*[@id='GBPJPY_detail_bid']").text
# ask = doc.xpath("//*[@id='GBPJPY_detail_ask']").text
# puts "Bid(売値)：#{bid}"
# puts "Ask(買値)：#{ask}"
#
# url = 'http://info.finance.yahoo.co.jp/fx/detail/?code=USDJPY=FX'
# doc = Nokogiri::HTML(open(url))
# bid = doc.xpath("//*[@id='USDJPY_detail_bid']").text
# ask = doc.xpath("//*[@id='USDJPY_detail_ask']").text
# puts "Bid(売値)：#{bid}"
# puts "Ask(買値)：#{ask}"


fx = FxMarket.new ;
# fx.update()
system("ruby make_setting.rb") ;
nn_conf = YAML.load_file("nn_setting.yml") ;
nn = NN.new(nn_conf)

usd_jpy_list = readCsv("data/USDJPY.csv") ;
eur_jpy_list = readCsv("data/EURJPY.csv") ;
gbp_jpy_list = readCsv("data/GBPJPY.csv") ;
cad_jpy_list = readCsv("data/CADJPY.csv") ;
aud_jpy_list = readCsv("data/AUDJPY.csv") ;

previous_datas = Array.new ;
usd_jpy_list.size.times do |time|
  if time != 0
    if usd_jpy_list[time+2] == nil
      break
    end
    traning_data={:input => {0 =>usd_jpy_list[time][2].to_f,1 =>eur_jpy_list[time][2].to_f.to_f,2 =>gbp_jpy_list[time][2].to_f.to_f,3 =>cad_jpy_list[time][2].to_f.to_f,4 =>aud_jpy_list[time][2].to_f.to_f},:output => {11 =>usd_jpy_list[time+2][2].to_f}} ;
    nn.training_one_time(traning_data) ;
    # traning_data[:output] = nn.nodes.last.get_w
    # previous_datas.push(traning_data) ;
    # make_yaml_file("fx_data.yml", previous_datas) ;
  end
end
make_yaml_file("nn.yml",nn) ;


# every(1.minutes, 'get_data') do
#
#
# if File.exist?("fx_data.yml") 
#   previous_datas = YAML.load_file("fx_data.yml") ;
# else
#   previous_datas = Array.new ;
# end
#
# today_datas = fx.get_today_data();
# traning_data={:input => {0 =>today_datas[:GBPJPY][:ask].to_f,1 =>today_datas[:USDJPY][:ask].to_f},:output => {5 =>today_datas[:USDJPY][:bid].to_f}} ;
# nn.training_one_time(traning_data) ;
# traning_data[:output] = nn.nodes.last.get_w
# previous_datas.push(traning_data) ;
# make_yaml_file("fx_data.yml", previous_datas) ;
# end
