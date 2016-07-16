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
require '~/fx/rubyOkn/GenerateGraph'
# require 'rubyOkn/GenerateGraph'
require 'clockwork'
require 'date'

#
# 様々なパターンを設定できるようにする
#

include BasicTool
include Clockwork

#  まず２日前の金額の呼び出し privous_money.yml
#  その日の為替を取得
#  差額を計算
#  差額に更新しておく 資源の期待値を更新しておく

$usd_jpy_list = nil ;
$eur_jpy_list = nil ;
$gbp_jpy_list = nil ;
$cad_jpy_list = nil ;
$aud_jpy_list = nil ;

class MyFxTool
  attr_accessor :nn ,:previous_data, :today_data, :previous_data_tmp;

  #
  # === 
  #
  def initialize(pattern = nil)
    system("ruby make_setting.rb") ;
    nn_conf = YAML.load_file("nn_setting.yml") ;
    @nn = NN.new(nn_conf)

    $usd_jpy_list = readCsv("data/USDJPY.csv") ;
    $eur_jpy_list = readCsv("data/EURJPY.csv") ;
    $gbp_jpy_list = readCsv("data/GBPJPY.csv") ;
    $cad_jpy_list = readCsv("data/CADJPY.csv") ;
    $aud_jpy_list = readCsv("data/AUDJPY.csv") ;
    @previous_data = nil
    ini_learning(pattern) ;
  end

  #
  # === 初期学習
  #
  def ini_learning(pattern)
    teacher_data = nil 
    case pattern
    when "usd_jpy" 
      teacher_data = $usd_jpy_list ;
    when "eur_jpy"
      teacher_data = $eur_jpy_list ;
    when "gbp_jpy"
      teacher_data = $gbp_jpy_list ;
    when "cad_jpy"
      teacher_data = $cad_jpy_list ;
    when "aud_jpy"
      teacher_data = $aud_jpy_list ;
    end

    @previous_data = nil
    @previous_datas = Array.new ;
    1000.times do |input_num|
      $usd_jpy_list.size.times do |time|
        if time != 0
          break if $usd_jpy_list[time+2] == nil
          begin
            sum = $usd_jpy_list[time][4].to_f+$eur_jpy_list[time][4].to_f+$gbp_jpy_list[time][4].to_f+$cad_jpy_list[time][4].to_f+$aud_jpy_list[time][4].to_f
            sum2 = $usd_jpy_list[time+1][4].to_f+$eur_jpy_list[time+1][4].to_f+$gbp_jpy_list[time+1][4].to_f+$cad_jpy_list[time+1][4].to_f+$aud_jpy_list[time+1][4].to_f
          rescue
            binding.pry ;
          end
          traning_data={:input => {0 =>$usd_jpy_list[time][4].to_f/sum,1 =>$eur_jpy_list[time][4].to_f/sum,2 =>$gbp_jpy_list[time][4].to_f/sum,3 =>$cad_jpy_list[time][4].to_f/sum,4 =>$aud_jpy_list[time][4].to_f/sum},:output => {11 =>teacher_data[time+1][4].to_f/sum2}} ;
          @nn.training_one_time(traning_data) ;

          @previous_data={:GBPJPY=>$gbp_jpy_list[time][4].to_f/sum, :USDJPY=>$usd_jpy_list[time][4].to_f/sum,:EURJPY =>$eur_jpy_list[time][4].to_f/sum, :CADJPY=>$cad_jpy_list[time][4].to_f/sum , :AUDJPY=>$aud_jpy_list[time][4].to_f/sum}
        end
      end
      # graph_data.push( test(usd_jpy_list, eur_jpy_list, gbp_jpy_list, cad_jpy_list, aud_jpy_list, nn) ) if input_num % 1 == 0
    end
  end

  #
  # === 定期的に実行する
  #
  def expect(pattern)
    pattern_name = nil 
    case pattern
    when "usd_jpy" 
      pattern_name = :USDJPY ;
    when "eur_jpy"
      pattern_name = :EURJPY ;
    when "gbp_jpy"
      pattern_name = :GBPJPY;
    when "cad_jpy"
      pattern_name = :CADJPY;
    when "aud_jpy"
      pattern_name = :AUDJPY;
    end

    every(1.day, 'get_data', :at => '01:00') do
      if !File.exist?("/home/okano/Copy/fx_log/fx_data_#{pattern}.yml") 
        data= Array.new ;
        make_yaml_file("/home/okano/Copy/fx_log/fx_data_#{pattern}.yml",data) ;
      end
      @today_data = get_today_data();  #今日のデータの取得する

      sum = @previous_data[:GBPJPY].to_f+@previous_data[:EURJPY].to_f+@previous_data[:USDJPY].to_f+@previous_data[:CADJPY].to_f+@previous_data[:AUDJPY].to_f ; #正規化するための合計値
      sum2 = @today_data[:GBPJPY].to_f+@today_data[:EURJPY].to_f+@today_data[:USDJPY].to_f+@today_data[:CADJPY].to_f+@today_data[:AUDJPY].to_f ; #本日のデータを正規化するための合計値

      traning_data={:input => {0 =>@previous_data[:USDJPY].to_f/sum,1 =>@previous_data[:EURJPY].to_f/sum,2 =>@previous_data[:GBPJPY].to_f/sum,3 =>@previous_data[:CADJPY].to_f/sum,4 =>@previous_data[:AUDJPY].to_f/sum},:output => {11 =>@today_data[pattern_name].to_f/sum2}} ;  #訓練データ(正規化したデータで
      @nn.training_one_time(traning_data) ; #nnで学習
      err =  @nn.nodes.last.get_w - @today_data[pattern_name].to_f/sum2

input_data={0 =>@today_data[:USDJPY].to_f/sum,1 =>@today_data[:EURJPY].to_f/sum,2 =>@today_data[:GBPJPY].to_f/sum,3 =>@today_data[:CADJPY].to_f/sum,4 =>@today_data[:AUDJPY].to_f/sum};  #訓練デー

      @nn.propagation(input_data) ;

      expect = @nn.nodes.last.get_w*sum - @previous_data[pattern_name].to_f ;
      @previous_data_tmp = @previous_data ;
      @previous_data = @today_data

     make_result(sum, sum2, pattern_name, pattern, err, expect) ;
      puts "############"
    end
  end

  #
  # === 予測結果の格納と
  #
  def make_result(sum, sum2, pattern_name, pattern, err, expect)
    result ={} ;
    result[:date] = Date.today.strftime("%Y.%m.%d") ;
    result[:nn_output] = @nn.nodes.last.get_w ;
    result[:err] = err
    result[:expect] = expect

    all_result = YAML.load_file("/home/okano/Copy/fx_log/fx_data_#{pattern}.yml") ;
    all_result.push(result) ;
    make_yaml_file("/home/okano/Copy/fx_log/fx_data_#{pattern}.yml",all_result) ;

    graph_data_list=[] ;
    graph_data =[] ;
    graph_data2 = [] ;
    all_result.each do |rlt|
      graph_data.push(rlt[:err]) ;
      graph_data2.push(rlt[:expect]) ;
    end
    graph_data_list.push(graph_data) ;
    graph_data_list.push(graph_data2) ;
    conf = GenerateGraph.make_default_conf
    conf[:graph_title]=Array.new ;
    conf[:graph_title][0] = "err"
    conf[:graph_title][1] = "expect"
    conf[:title] = "/home/okano/Copy/fx_log/fx_data_#{pattern}" ;
    GenerateGraph.list_time_step(graph_data_list, conf)

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

# usd_jpy, など予想した為替の名前を引数にする
fx = MyFxTool.new(ARGV[0]) ;
fx.expect(ARGV[0]) ;

