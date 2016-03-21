#!/usr/bin/ruby
# -*- encoding: utf-8 -*-

$LOAD_PATH.push(File::dirname($0)) ;
require "pry"
require "yaml"
require 'rubyOkn/BasicTool'
#require '/home/okano/lab/oknLib/rubyOkn/BasicTool'

include BasicTool

#
# == リンク
#
class Link
  attr_accessor :id,:from, :to, :w

  def initialize(from = nil, to = nil, id)
     @from = from if from != nil ;
     @to = to if to != nil ;
     @w = rand(-1.0...1.0) ;      #重みを決定
     @id = id ;
  end

  #
  # === linkのto方向のノードを取得
  #
  def get_to  
    return @to ;
  end

  #
  # === linkの from 方向のノードを取得
  #
  def get_from
    return @from ;
  end

  #
  # === linkのto方向のノードをセット
  #
  def set_to(to)
    @to = to ;
  end

  #
  # === linkのfrom方向のノードをセット
  #
  def set_from(from)
    @from = from ;
  end

  #
  # === linkの重みを返す
  #
  def get_w()
    return @w ;
  end

  #
  # === linkの重みをセット
  #
  def set_w(w)
    @w = w ;
  end

end

#
# 実行用
#
if($0 == __FILE__) then
  
end


