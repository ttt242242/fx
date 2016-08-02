#!/usr/bin/ruby
# -*- encoding: utf-8 -*-

$LOAD_PATH.push(File::dirname($0)) ;
require "pry"
require "yaml"
require '/home/okano/lab/tkylibs/rubyOkn/BasicTool'
require '/home/okano/lab/tkylibs/rubyOkn/StringTool'

include BasicTool
include StringTool;

module TexTool

  #
  # === RRSPの結果をtexの表を生成できるtxt出力
  #
  def create_tex_table_rrsp
    result = YAML.load_file(".yml")
  end

  module_function :cut_hash  ;
end


#
# 実行用
#
if($0 == __FILE__) then
  
end


