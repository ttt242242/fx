#!/usr/bin/ruby
# -*- encoding: utf-8 -*-

$LOAD_PATH.push(File::dirname($0)) ;
require 'nokogiri'
require 'open-uri'
require 'yaml'
require '~/lab/fx/Link'
require '~/lab/fx/Node'
require '~/lab/fx/NN'
# require 'Node'
# require 'NN'
# require 'rubyOkn/BasicTool'
require '~/lab/oknlibs/rubyOkn/BasicTool'
require '~/lab/oknlibs/rubyOkn/GenerateGraph'
# require 'rubyOkn/GenerateGraph'
require 'clockwork'
require 'date'

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
    exchange[:EURJPY] = get_exchange_info("EURJPY") ;
    exchange[:CADJPY] = get_exchange_info("CADJPY") ;
    exchange[:AUDJPY] = get_exchange_info("AUDJPY") ;

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

    # return {:bid => bid, :ask => ask} ;
    return bid

  end 
end

def test(usd_jpy_list, eur_jpy_list, gbp_jpy_list, cad_jpy_list, aud_jpy_list, nn)
  test_data_id = rand(usd_jpy_list.size) ;
  while ( test_data_id > ( usd_jpy_list.size - 2 ) ) || test_data_id == 0
    test_data_id = rand(usd_jpy_list.size) ;
  end

  begin
  sum = usd_jpy_list[test_data_id][2].to_f+eur_jpy_list[test_data_id][2].to_f+gbp_jpy_list[test_data_id][2].to_f+cad_jpy_list[test_data_id][2].to_f+aud_jpy_list[test_data_id][2].to_f
  rescue
    p usd_jpy_list[test_data_id][2].to_f
    p eur_jpy_list[test_data_id][2].to_f
    p gbp_jpy_list[test_data_id][2].to_f
    p cad_jpy_list[test_data_id][2].to_f
    p aud_jpy_list[test_data_id][2].to_f
    binding.pry ;
  end
  # sum = 150
  

  traning_data={:input => {0 =>usd_jpy_list[test_data_id][2].to_f/sum,1 =>eur_jpy_list[test_data_id][2].to_f/sum,2 =>gbp_jpy_list[test_data_id][2].to_f/sum,3 =>cad_jpy_list[test_data_id][2].to_f/sum,4 =>aud_jpy_list[test_data_id][2].to_f/sum},:output => {11 =>usd_jpy_list[test_data_id+1][2].to_f/sum}} ;

  # traning_data={:input => {0 =>usd_jpy_list[test_data_id][2].to_f/150.0,1 =>eur_jpy_list[test_data_id][2].to_f/150.0,2 =>gbp_jpy_list[test_data_id][2].to_f/150.0,3 =>cad_jpy_list[test_data_id][2].to_f/150.0,4 =>aud_jpy_list[test_data_id][2].to_f/150.0},:output => {11 =>usd_jpy_list[test_data_id+1][2].to_f/150.0}} ;
  nn.training_one_time(traning_data) ;
  err =  nn.nodes.last.get_w - usd_jpy_list[test_data_id+1][2].to_f/sum
  
  return err
  # p usd_jpy_list[1002][2].to_f/150.0

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

# i=0
graph_data =[] ;
previous_data = nil
previous_datas = Array.new ;
1000.times do |input_num|
  usd_jpy_list.size.times do |time|
    if time != 0
      break if usd_jpy_list[time+2] == nil
      begin
      sum = usd_jpy_list[time][5].to_f+eur_jpy_list[time][5].to_f+gbp_jpy_list[time][5].to_f+cad_jpy_list[time][5].to_f+aud_jpy_list[time][5].to_f
      sum2 = usd_jpy_list[time+1][5].to_f+eur_jpy_list[time+1][5].to_f+gbp_jpy_list[time+1][5].to_f+cad_jpy_list[time+1][5].to_f+aud_jpy_list[time+1][5].to_f
      rescue
        binding.pry ;
      end
      # sum = 150
      # traning_data={:input => {0 =>usd_jpy_list[time][5].to_f/150.0,1 =>eur_jpy_list[time][5].to_f/150.0,5 =>gbp_jpy_list[time][5].to_f/150.0,3 =>cad_jpy_list[time][5].to_f/150.0,4 =>aud_jpy_list[time][5].to_f/150.0},:output => {11 =>usd_jpy_list[time+5][5].to_f/150.0}} ;
      traning_data={:input => {0 =>usd_jpy_list[time][5].to_f/sum,1 =>eur_jpy_list[time][5].to_f/sum,5 =>gbp_jpy_list[time][5].to_f/sum,3 =>cad_jpy_list[time][5].to_f/sum,4 =>aud_jpy_list[time][5].to_f/sum},:output => {11 =>usd_jpy_list[time+1][5].to_f/sum2}} ;
      nn.training_one_time(traning_data) ;

      previous_data={:GBPJPY=>gbp_jpy_list[time][5].to_f/sum, :USDJPY=>usd_jpy_list[time][5].to_f/sum,:EURJPY =>eur_jpy_list[time][5].to_f/sum, :CADJPY=>cad_jpy_list[time][5].to_f/sum , :AUDJPY=>aud_jpy_list[time][5].to_f/sum}

      # traning_data[:output] = nn.nodes.last.get_w
      # previous_datas.push(traning_data) ;
      # make_yaml_file("fx_data.yml", previous_datas) ;
      # p i
      # i+=1
    end
  end
  graph_data.push( test(usd_jpy_list, eur_jpy_list, gbp_jpy_list, cad_jpy_list, aud_jpy_list, nn) ) if input_num % 1 == 0
end


test(usd_jpy_list, eur_jpy_list, gbp_jpy_list, cad_jpy_list, aud_jpy_list, nn) ;

# make_yaml_file("nn.yml",nn) ;

graph_data=[]
# 以下定期的に実行
every(1.day, 'get_data') do


if !File.exist?("/home/okano/Copy/fx_data.yml") 
  data= Array.new ;
  make_yaml_file("/home/okano/Copy/fx_data.yml",data) ;
end

today_data = fx.get_today_data();

#====================
sum = previous_data[:GBPJPY].to_f+previous_data[:EURJPY].to_f+previous_data[:USDJPY].to_f+previous_data[:CADJPY].to_f+previous_data[:AUDJPY].to_f
sum2 = today_data[:GBPJPY].to_f+today_data[:EURJPY].to_f+today_data[:USDJPY].to_f+today_data[:CADJPY].to_f+today_data[:AUDJPY].to_f


traning_data={:input => {0 =>previous_data[:USDJPY].to_f/sum,1 =>previous_data[:EURJPY].to_f/sum,2 =>previous_data[:GBPJPY].to_f/sum,3 =>previous_data[:CADJPY].to_f/sum,4 =>previous_data[:AUDJPY].to_f/sum},:output => {11 =>today_data[:USDJPY].to_f/sum2}} ;
nn.training_one_time(traning_data) ;
previous_data = today_data
#====================

result ={} ;
result[:date] = Date.today.strftime("%Y.%m.%d") ;
result[:nn_output] = nn.nodes.last.get_w ;
err =  nn.nodes.last.get_w - today_data[:USDJPY].to_f/sum2
result[:err] = err

all_result = YAML.load_file("/home/okano/Copy/fx_data.yml") ;
all_result.push(result) ;
make_yaml_file("/home/okano/Copy/fx_data.yml",all_result) ;

graph_data =[] ;
all_result.each do |rlt|
  graph_data.push(rlt[:err].abs) ;
end
conf = GenerateGraph.make_default_conf
GenerateGraph.time_step(graph_data, conf)

end

