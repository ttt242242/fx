#!/usr/bin/ruby
# -*- encoding: utf-8 -*-

$LOAD_PATH.push(File::dirname($0)) ;
require "pry"
require "yaml"
require '/home/okano/lab/tkylibs/rubyOkn/BasicTool'
require '/home/okano/lab/tkylibs/rubyOkn/StringTool'

include BasicTool
include StringTool;

class  
  attr_accessor :test
  def initialize()
  end
end

#
# 実行用
#
if($0 == __FILE__) then
  
end


