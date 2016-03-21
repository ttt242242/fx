#!/usr/bin/ruby
# -*- encoding: utf-8 -*-

$LOAD_PATH.push(File::dirname($0)) ;
require "pry"
require "yaml"
# require '/home/okano/lab/tkylibs/rubyOkn/BasicTool'
# require '/home/okano/lab/tkylibs/rubyOkn/StringTool'
#
# include BasicTool
# include StringTool;

#
# == 根本要素
#     -位置情報
#     -id、名前
#       などを保持 
#
class Object
  attr_accessor :id, :name, :pos

  #
  # === initializer
  #       id integer
  #       name string
  #       pos hash {x=> , y=>}
  #
  def initialize(id=nil, name=nil, pos=nil)
    @id = id if id != nil 
    @name = name if name != nil 
    @pos = pos if pos!= nil 
  end

  def set_id(id)
    @id = id
  end

  def set_name(name)
    @name = name
  end

  def set_pos(pos)
    @pos = pos
  end

  def get_id()
    return name
  end

  def get_name()
    return name
  end

  def get_pos()
    return pos
  end

end

#
# 実行用
#
if($0 == __FILE__) then
  
end


