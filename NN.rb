#!/usr/bin/ruby
# -*- encoding: utf-8 -*-

$LOAD_PATH.push(File::dirname($0)) ;
require "pry"
require "yaml"
require "/home/okano/fx/Node"
# require "Node"
require "/home/okano/fx/Link"
# require "Link"
require '/home/okano/lab/oknlibs/rubyOkn/BasicTool'
# require 'rubyOkn/BasicTool'

include BasicTool


#
# == フィードフォワードネットワークの実験用　3層の実装 シンプルなパーセプトロンとは別で
# NNの形 などはこちらで決めてしまう
#
class NN 
  attr_accessor :links, :nodes, :conf, :errs, :threshold,:n

  def initialize(conf)
    @conf = conf ;
    @links = [] ;   
    @nodes = [] ;
    @errs = {} ;    #出力層と教師データとの誤差の出力
    @n = 0.1 ;  # 学習率
    @teacher_datas = {} ;
    @threshold = conf[:threshold] ; #しきい値
    # @threshold = 0; #しきい値
    create_nn()  #設定ファイルからNNを生成
  end
 
  #
  # === 設定ファイルからNNを生成
  #
  def create_nn()
    create_nodes(@conf[:all_node_num]);  #入力層、隠れそう、出力層の初期化
    create_links(@conf[:links_conf]);  #リンクをつなげる
  end

  #
  # === 一層のノード群の生成
  #
  def create_nodes(node_num)
    node_num.times do |n|
     @nodes.push(Node.new(0,n)) ;
    end
  end

  #
  # === リンクをつなげる
  #
  def create_links(links_conf)
    links_conf.each_with_index do |link_conf,i|
      link = Link.new(@nodes[link_conf[:from]],@nodes[link_conf[:to]], i) ;
      @links.push(link);
      @nodes[link_conf[:from]].set_to_link(link) ;
      @nodes[link_conf[:to]].set_from_link(link) ;
    end
  end

  #
  # === 入力と伝搬
  #
  def propagation(input_data)
    input_practice_data(@conf[:input_node_num], input_data) ; # 初期のインプット

    # 全ノードの更新  下のノードから
    @nodes.each do |node|
      if !input_node?(node)  # 入力層でなければ
        from_links = node.get_from_links ;
        sum_value = 0.0 ;
        from_links.each do |link|
          if link.get_from.get_w().nan? ||  link.get_w().nan?
            binding.pry ;
          end

          sum_value += link.get_from.get_w() * link.get_w() ;
        end
    if ( sum_value - @threshold ).nan?
      binding.pry ;
    end
        node.input(sum_value - @threshold) ;
      end
    end
  end

  
  #
  # === 訓練データの入力
  #
  def input_practice_data(input_node_num,input_data)
    input_node_num.times do |n|
      begin
        if input_data[n].nan?
          binding.pry ;
        end
      rescue
        binding.pry ;
      end
      @nodes[n].set_w(input_data[n]) ;
    end
  end

  #
  # === 出力値との誤差を求める
  #
  def calc_err(teacher_datas)
    i = @conf[:all_node_num]-1 ;
    min_output_num = @conf[:all_node_num]-@conf[:output_node_num] -1 ;
    while i > min_output_num
      @errs[i] = -1 * (teacher_datas[i] - @nodes[i].get_w ) ;
      i -= 1 ;
      end
  end

  #
  # === 誤差逆伝搬
  # 各リンク毎
  #
  def back_propagation()
    delta = {} ;
    @links.reverse_each do |link|
      to_node = link.get_to ;
      from_node = link.get_from ;
      if output_node?(to_node)  #出力ノードに結合していれば
        delta[link.id] = @errs[to_node.id] * to_node.get_w * (1.0 - to_node.get_w);
      else #出力層でなければ
        delta[link.id] = calc_delta(delta,link) * to_node.get_w * (1.0 - to_node.get_w) ;
      end
      delta_weight = -1.0 * @n * delta[link.id] * from_node.get_w();
      link.set_w(link.get_w + delta_weight) ;
    end
  end
 
  #
  # === 上のノード
  #
  def calc_delta(delta, link)
    from = link.get_to ;
    sum_value = 0.0 ;
    from.get_to_links.each do |link| 
       sum_value += link.get_w * delta[link.id] 
    end
    return sum_value ;
  end

  #
  # === 入力ノードかどうかの判定
  #
  def input_node?(node)
    if node.get_id <  @conf[:input_node_num]
      return true  ;
    else
      return false ;  
    end
  end

  #
  # === 出力ノードかどうかの判定
  # ノードの後ろから数える
  #
  def output_node?(node)
    min_output_num = @conf[:all_node_num] - @conf[:output_node_num] -1;  #出力ノードの中で最も小さいid
    if node.id > min_output_num 
      return true ;
    else
    return false ;
    end
  end

 def training_one_time(training_datas)
    training_data = training_datas[:input] ;
    teacher_datas= training_datas[:output] ;
    propagation(training_data) ;
    calc_err(teacher_datas) ;
    back_propagation ;

    nodes.last.get_w ;
    teacher_datas= training_datas[:output] ;
    err = ( nodes.last.get_w - teacher_datas[nodes.last.id] ).abs
    return err
end 
end


#
# === トレーニング
#
def training(nn, conf)
  count = 0 ;
  100000.times do 
    t = rand(conf[:training_data].size-1)
    err = nn.training_one_time(conf[:training_data][t])    
    if err < 0.01
      count += 1 ;    #教師データとの誤差が小さければ
    else
      count = 0 ;
    end
   break  if count > 100 # 正解が連続100回持続すれば
  end
end



def test(nn, conf)
  test_num = 100 ;
  test_num.times do |num|
    t = rand(conf[:training_data].size)
    training_data = conf[:training_data][t][:input] ;
    nn.propagation(training_data) ;
    teacher_datas= conf[:training_data][t][:output] ;

    puts "#{ nn.nodes.last.get_w.round(3) },#{ teacher_datas[5] }"
    if ( nn.nodes.last.get_w.round(3)- teacher_datas[5] ).abs < 0.1
      puts "○" ;
    else
      puts "☓" ;
    end
  end
end

#
# 実行用
#
if($0 == __FILE__) then
  conf = YAML.load_file("nn_setting.yml") ;
  nn = NN.new(conf) ;
  # 訓練
  training_num = 10000 ;
  err = 100 ;
  training(nn, conf) ; #訓練
  test(nn, conf) ; #テスト
end


