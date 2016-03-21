# -*- coding: utf-8 -*-

$LOAD_PATH.push(File::dirname($0)) ;
require "pry"
require "yaml"
require "csv"
require "narray"
# require "marshal"

#
# == 自分のrubyライブラリ
#文章関係の処理を行うライブラリ
# Author::Takuya Okano
# Version::
# Date::
#
module MathTool

  #
  # ===ボックス―ミューラー法をよる正規分布乱数発生
  # @param mu flout 平均
  # @param sigma flout 標準偏差
  # @return ボックスミューラー法に従う正規分布に従う乱数を生成
  #
  def normal_rand(mu = 0,sigma = 1.0)
    a, b = rand(), rand() ;
    return (Math.sqrt(-2*Math.log(rand()))*Math.sin(2*Math::PI*rand()) * sigma) + mu
  end
  module_function :normal_rand ;

  #
  # ===ポアソン分布に従う乱数を発生する
  #
  def poisson_rand(mu=0.0)
    lambda = Math.exp(-mu)
    k = 0
    p = 1.0
    while p >= lambda
      p *= rand()
      k += 1
    end
    return k - 1
  end
  module_function :poisson_rand;


  #
  # === シグモイド関数で変換した値を返す
  #
  def sigmoid_fun(x, a=1)
    return (1.0/(1.0+Math.exp(-1.0 * a * x))) ;
  end
  module_function :sigmoid_fun;

  #
  # === シグモイド関数の逆関数で変換した値を返す
  #
  def sigmoid_inverse(x, a=1)
    if x == 0.0
      x = 0.00001
    elsif x ==1.0
      x = 0.99999
    end
    return Math.log(x/(1.0-x)) ;
  end
  module_function :sigmoid_inverse;

  #
  # === 双曲線関数　[0, 無限]　を[0.0, 1.0]の値に変換
  #
  def hyperbolic(x)
    exp = Math.exp(-x) ;
    exp2 = Math.exp(x) ;
    result = (exp2-exp)/ (exp2+exp) ;
    return result ;
  end
  module_function :hyperbolic;

  
end

