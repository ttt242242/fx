# -*- coding: utf-8 -*-

$LOAD_PATH.push(File::dirname($0)) ;
require "pry"
require "yaml"
require "csv"
require "narray"
# require "marshal"

#
# == 自分のrubyライブラリ
#
# Author::Takuya Okano
# Version::
# Date::
#
module BasicTool

  ###########################################
  #
  #  hashとarray関係
  #
  ##########################################

  #
  # hashのvalueの値でソートする.昇順
  #
  def hash_v_sort(hash)
    return hash.sort{|(k1, v1), (k2, v2)| v2 <=> v1}
  end

  #
  # === 元のhashをsizeでカットする
  #
  def cut_hash(hash, size)
    result_hash = Hash.new ;

    # すでにhashが指定したサイズ以下なら
    if hash.size < size
      return hash
    end   


    hash.each_with_index do |(k, v), i|
      if i == size - 1
        return result_hash ;
      end
      result_hash[k] = v ;
    end
  end

  module_function :cut_hash  ;

  #
  # === 回数から平均を求める関数
  #
  # @param average 現在の平均
  # @param add_value 加える値
  # @param  num  回数
  # @return average 平均
  #
  def get_ave2(average, add_value, num)
    average = (num.to_f/(num.to_f+1.0))*average + (1.0/(num.to_f+1.0))* add_value ;
    return average ;
  end

  module_function :get_ave2  ;
  #
  # === 配列の要素を数え上げ、要素→　要素数の形にする。
  # @param
  # @return Hash = {要素=>要素数,, ,  
  #
  def array_to_numarray(array)
  #とれた文字をハッシュ化する
  hash = Hash.new ;
  array.each do |word|
    if hash[word] == nil
      hash[word] = 0
    end
    hash[word] += 1 ; 
  end
  return hash ;
  end
  module_function :array_to_numarray  ;

  #
  # === hashデータのmin-max正規化したものを返す
  # valueについて
  #
  def min_max_normalization_hash(hash)
    result_hash = Hash.new ;
    min_max = get_max_min_v_from_hash(hash)
    hash.each do |h|
      h[1] = (h[1].to_f - min_max[:min].to_f)/(min_max[:max].to_f-min_max[:min].to_f) ;
      result_hash[h[0]] = h[1] ;
  end 
    return result_hash ;
  end

  #
  # hashデータのvのmaxとminを取得
  #
  def get_max_min_v_from_hash(hash)
    result = Hash.new ;
    result[:max] = 0 ;
    result[:min] = 100000 ;

  hash.each_with_index do |(k,v),i|
    # sorted_array.push({k => hyperbolic(v)}) ;
    # sorted_array.push({k => v}) ;
    if result[:max] < v
      result[:max] = v ;
    end
    if result[:min] > v
      result[:min] = v ;
    end
  end

  return result ;
  end
  module_function :get_max_min_v_from_hash  ;

  #
  # === 整数配列の平均を返す
  #
  def get_array_ave(array)
    return array.inject(:+)/array.length ;
  end

  #
  # === 整数配列の標準偏差を返す
  #
  def get_array_std(array)
    narray = NArray.to_na(array)
    if narray.stddev.nan?
      return 0 ;
    else
      return narray.stddev ;
    end
  end 

  #
  # == arrayの相乗平均を返す
  #
  def create_geometric_mean(array)
    log_array = create_log_array(array)  ;
    
    return Math.exp(get_array_ave(log_array)) ;
  end

  #
  # === 整数配列をすべて対数に変換
  #
  def create_log_array(array)
    result_array = Array.new ;
    array.each do |a|
      result_array.push(Math.log(a))
    end

    return result_array ;
  end 

  #
  # === 整数配列の合計値を返す
  #
  def get_array_sum(array)
    return array.inject{|sum, n| sum + n} ;
  end

  ##########################################################


#
# === 
#
def time_stamp
  day = Time.new ;
  stamp = day.year.to_s << "-" << sprintf("%02d", day.month) << "-" << sprintf("%02d", day.day)<< "-" << sprintf("%02d", day.hour) << "" << sprintf("%02d", day.min)
  return stamp
end

  module_function :time_stamp  ;

#
# === 
#
def time_stamp_id
  day = Time.new ;
  stamp = sprintf("%02d", day.month)  << sprintf("%02d", day.day)<< sprintf("%02d", day.hour) << sprintf("%02d", day.min)
  return stamp
end

  module_function :time_stamp_id  ;


  def load_yml(log_name)
    return YAML.load_yml(log_name)
  end

  module_function :load_yml  ;

  def deep_copy(obj)
    return Marshal.load(Marshal.dump(obj))
  end

  module_function :deep_copy  ;

  #
  # === 配列の要素をすべて表示する
  # 
  def printArray(array) 
    array.each{ |element|
      p element ;
    }
  end

  #
  # === 整数(num)の桁数を返す
  #
  def count_digit(num)
    return num.to_s.length ;
  end



  ################################################################
  #
  # txtfile関係
  #
  ################################################################

  #
  # === 指定したディレクトリがなければ、ディレクトリを作成するメソッド
  #
  def mkdir(logdir)
    FileUtils.mkdir(logdir) unless FileTest.exist?(logdir) ;
  end

  
  #
  # === yamlファイルの作成
  #
  def makeYamlFile(fileName, data)
    open(fileName, "w") do |e|
      YAML.dump(data, e) ;
    end
  end

  #
  # === 上と機能同じ
  #
  def make_yaml_file(fileName, data)
    open(fileName, "w") do |e|
      YAML.dump(data, e) ;
    end
  end

  #
  # === dataから一行づつ読み込んで表示する
  #
  def readOneLineFromFile(data)
    File.open data do |f|
      while line = f.gets
        puts line ;
      end
    end
  end

  #
  # === dataから一行づつ一文字づつ区切り配列に保存していく
  #
  def txtFileToArray(data)
    array = Array.new ;
    File.open data do |f|
      while line = f.gets
        a = line.split(/\s+/) 
        p a ;
        array.push(a)
      end
    end
    return array ; 
  end

  #
  # === ファイルに書き込む
  #
  def writeData(file,data, option="w")
    File.open(file, option) do |f|
      f.puts(data) ;
    end
  end

  #
  # === ファイルに書き込む
  # 一つのデータを格納する毎に改行
  #
  def writeData2(file,data, option)
    File.open(file, option) do |f|
      f.puts(data) ;
    end

  end
  module_function :writeData2  ;

  #
  # === ファイルtxtデータを普通に読み込む、string
  #
  def getStrDataFromTxt(data)
    f = open(data) ;
    str = "" 
    while line = f.gets
      str << line 
    end
    return str ;
  end

  ################################################################
  #
  # CSVfile関係
  #
  ################################################################

  #
  # === data(一次元データ)をcsvに書き込む
  # 
  def writeCsv(csvFile, data)
    CSV::open(csvFile, "wb") do |csv|
      csv << data ;
    end
  end

  #
  # === csvから一次元配列へ
  #
  def readCsv(csvFile)
    array = [] ;
    i = 0
    CSV.foreach(csvFile,encoding: "Shift_JIS:UTF-8" ) do |file|
      array.push(file) ;
      if i == 100
        break
      end
      i +=1
    end
    return array ;
  end
  module_function :readCsv ;

  #
  # === csvデータをハッシュデータに落としこむ.できてない
  # arrayで返すと二列のcsvを左をkey, 右をvalueとして返すメソッドの作成j
  # 
  def csvToHash()
    keys = [:name,  :age,  :height]
    CSV.foreach("test.csv",  'r') do |row|
      p hashed_row = Hash[*keys.zip(row).flatten] # => {:age=>"30",  :height=>"180",  :name=>"Yamada"}
      p hashed_row[:name]   # => "Yamada"
      p hashed_row[:age]    # => "30"
      p hashed_row[:height] # => "180"

      csArray(hashed_row)
  end
  end
  
  #***********************************************
  #
  # 関数変換、乱数関係
  #
  #***********************************************

  include Math
  #
  # ===ボックス―ミューラー法をよる正規分布乱数発生
  # Box-Muller method
  def normal_rand(mu = 0,sigma = 1.0)
    a, b = rand(), rand()
    (Math.sqrt(-2*Math.log(rand()))*Math.sin(2*PI*rand()) * sigma) + mu
  end
  module_function :normal_rand ;

  #
  # ===ポアソン分布に従う乱数を発生する
  #
  def poisson_rand(mu)
    lambda = Math.exp(-mu)
    k = 0
    p = 1.0
    while p >= lambda
      p *= self.rand()
      k += 1
    end
    return k - 1
  end
  module_function :poisson_rand;


  #
  # === シグモイド関数で変換した値を返す
  #
  def sigmoid_fun(x, a=1)
    result= (1.0/(1.0+Math.exp(-1.0 * a * x))) ;
    if result.nan?
      binding.pry ;
    end
    return result
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
  # === シグモイド変換
  #
  def sigmoid_change(x,noize,a=1)
    changed_x = sigmoid_inverse(x)  ;
    changed_x = changed_x + noize ; 
    new_x = sigmoid_fun(changed_x) ;
    return new_x ;
  end

  module_function :sigmoid_change;

  module_function :printArray ;
  module_function :makeYamlFile;
  module_function :make_yaml_file;
  module_function :count_digit;
  module_function :readOneLineFromFile;
  module_function :txtFileToArray;
  module_function :writeData;
  module_function :getStrDataFromTxt;
  module_function :writeCsv;
end


#
# 実行用
#
if($0 == __FILE__) then
  # BasicTool.txtFileToArray(ARGV[0]) ;
  # p BasicTool.readCsv("/home/okano/nodaSemi/okano/resourceSharing/test.csv") ;
  data = Hash.new 
  d = 0 ;
  1000.times do
    loop {
      d = BasicTool.normal_rand(0.1, 0.05).round(2)
      if (d < 0) || (d > 1)
        d = BasicTool.normal_rand(0.2, 0.04).round(2)
      else
        break ;
      end
    }
    if data[d] == nil 
      data[d] = 1 ;
    else
      data[d] +=1 ;
    end

  end

  i = 0.00 ;
  loop{ 
    if data[i] == nil

    else
      printf("%0.2f", i) ;
      data[i].times do
        printf("*") ;
      end
      printf("\n")  ;
    end
    i += 0.01 ;
    i = i.round(2) 
    if i > 1
      p i ;
      break ;
    end
  }

end





