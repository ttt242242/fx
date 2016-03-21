#!/usr/bin/ruby
# -*- encoding: utf-8 -*-

$LOAD_PATH.push(File::dirname($0)) ;
require "pry"
require "yaml"
require 'rubyOkn/BasicTool'
# require '/home/okano/lab/oknLib/rubyOkn/BasicTool'

include BasicTool

#
# ニューロン
#
class Node
  attr_accessor :id, :w, :threshold, :link_list, :from_links, :to_links ;

  def initialize(threshold=0.5, id=nil)
    @id = id ;
    @threshold = threshold;  #しきい値
    @link_list = [] ;
    @from_links = [] ;
    @to_links = [] ;
    @w = 0.0 ;
  end

  
  #しきい値をセット
  def set_threshold(threshold)
    @threshold = threshold   ;  #しきい値をセット
  end

  #重みを返す 
  def get_w
    return @w ;
  end

  #しきい値を返す
  def get_threshold
    return @threshold ;
  end

  def set_from_link(link)
    @from_links.push(link) ;
  end
  
  def set_to_link(link)
    @to_links.push(link) ;
  end

  def get_from_links()
    return @from_links ;
  end

  def get_to_links()
    return @to_links ;
  end

  #
  # === link_listにlinkを加える
  #
  def add_link(link)
    link_list.push(link) ;
  end
 
  #
  # === 発火するかどうか
  #     check to fire or not
  #
  def input(sum_value)
    @w = sigmoid_fun(sum_value)  ;
  end

  #
  # === ノードの値をセット
  #
  def set_w(w)
    @w = w;
  end

  
  def get_id()
    return @id ;
  end

end

#
# 実行用
#
if($0 == __FILE__) then
  
end


