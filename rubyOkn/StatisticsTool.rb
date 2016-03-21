# -*- coding: utf-8 -*-

$LOAD_PATH.push(File::dirname($0)) ;
require "pry"
require "gnuplot"

#
# == 自分のrubyのグラフ周りのライブラリ
#
# Author::Takuya Okano
# Version::
# Date::
#
module GraphTool
  
  def 
  module_function :makeAllGraphByHashArray;

end


#
# 実行用
#
if($0 == __FILE__) then
  BasicTool.txtFileToArray(ARGV[0]) ;
end



