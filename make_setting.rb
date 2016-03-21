#!/usr/bin/ruby
# -*- encoding: utf-8 -*-

$LOAD_PATH.push(File::dirname($0)) ;
require "pry"
require "yaml"
require 'rubyOkn/BasicTool'

include BasicTool
# include StringTool;


#
# == NNの実験用　3層のNNの実装 シンプルなパーセプトロンとは別で
# NNの形 などはこちらで決めてしまう
#
conf = Hash.new() 
conf[:all_node_num] = 0 
#入力層のノード数
puts "input input's node num(integer)" ;

# conf[:input_node_num] = gets.to_i  ;
conf[:input_node_num] = 5  ;
conf[:all_node_num] += conf[:input_node_num]  ;
#隠れそうの層数
puts "input number of the layer(integer)"
# layer_num = gets.to_i
layer_num = 1 ;
conf[:hidden_layer] = Array.new 
layer_num.times do 
  #層数分繰り返す
  puts "input node num in layer #{layer_num}"
  # node_num = gets.to_i ;
  node_num =6 ;
  conf[:hidden_layer].push(node_num) ;
  conf[:all_node_num] += node_num ;
end
  

#出力層のノード数
puts "input number of output's node(integer)"
# conf[:output_node_num] = gets.to_i
conf[:output_node_num] = 1
conf[:all_node_num] += conf[:output_node_num] ;

conf[:layer_length] = layer_num + 2 

conf[:links_conf] =[{:from =>0, :to =>5 }, {:from =>1, :to =>5 },{:from =>0, :to =>6 },{:from =>0, :to =>7 },{:from =>1, :to =>8 },{:from =>1, :to =>9 },{:from =>3, :to =>6 },{:from =>4, :to =>9 },{:from =>2, :to =>10 },{:from =>2, :to =>5 },{:from =>2, :to =>7 },{:from =>2, :to =>9 },{:from =>3, :to =>10 },{:from =>3, :to =>7 },{:from =>3, :to =>5 },{:from =>3, :to =>9 },{:from =>4, :to =>5 },{:from =>4, :to =>7 },{:from =>4, :to =>10 },{:from =>4, :to =>9 },{:from =>4, :to =>6 },{:from =>5, :to =>11 },{:from =>6, :to =>11 },{:from =>7, :to =>11 },{:from =>8, :to =>11 },{:from =>9, :to =>11 },{:from =>10, :to =>11 }]

conf[:training_data] = [
# {:input => {0 => 0,1 => 0},:output =>{5 => 0}}, 
# {:input => {0 => 0,1 => 1},:output =>{5 => 1}}, 
# {:input => {0 => 1,1 => 0},:output =>{5 => 1}}, 
# {:input => {0 => 1,1 => 1},:output =>{5 => 1}}
]
conf[:threshold]  = 0.5 ;

makeYamlFile("nn_setting.yml", conf) 


