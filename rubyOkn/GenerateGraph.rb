# -*- coding: utf-8 -*-

$LOAD_PATH.push(File::dirname($0)) ;
require "pry"
require "gnuplot"

#
# == 自分のrubyのグラフ周りのライブラリ
#  0324最新版
#
# Author::Takuya Okano
# Version::
# Date::
#
module GenerateGraph

  #
  # === デフォルトのconfを設定
  #
  def make_default_conf(title=nil)
    conf ={}
    conf[:title] = "reward" 
    conf[:linewidth] = 0.4 ;
    conf[:ds] = "lp" ;
    conf[:hanreiPos] = "right bottom" ;
    # conf[:hanreiPos] = "outside" ;
    conf[:plot_size] = "1, 1" ;
    conf[:origin] = "0.0, 0.0" ;
    conf[:ylabel] = "average exploration" ;   
    conf[:xlabel] = "cycle" ;
    conf[:graph_title] = "average epsilon"
    conf[:is_straight_line] = true ;
    # conf[:is_xlogscale] = true ;
    conf[:is_xlogscale] = false;
    # conf[:is_ylogscale] = true ;
    conf[:is_ylogscale] = false ;
    conf[:scale] = 1 ;
    conf[:is_errbar] = false;
    # conf[:is_errbar] = true;
    # if conf[:is_errbar]
    conf[:err_scale] = 1000 ;
    # conf[:err_scale] = 1 ;
    conf[:err_title] = "standard deviation" ;
    conf[:err_linewidth] = 1.0 ;

    # conf[:x_range] ="[0:1]"
    # conf[:y_range] = "[0:1]"

    return conf
  end
  module_function :make_default_conf  ;

  def set_plot_conf(plot, conf)
        plot.title conf[:g_title] if conf[:g_title] != nil
        plot.output conf[:title]+".eps"
        # plot.output conf[:title]+".eps"
        plot.ylabel conf[:ylabel]
        plot.xlabel conf[:xlabel]

        plot.set 'terminal postscript 16 eps enhanced color ' #必要epsで保存するには
        plot.set 'key '+conf[:hanreiPos]  #凡例の位置を調整

        plot.size conf[:plot_size] #"1,0.8"
        plot.origin conf[:origin] #"0.0, 0.0"
        plot.grid

  end
  module_function :set_plot_conf  ;


  #
  # === 普通に描写
  #
  def data_set(plot, x, y, conf, title=nil)
    plot.data << Gnuplot::DataSet.new( [x,y] ) do |ds|
      ds.with = conf[:ds]   #line＋point
      if title == nil
        ds.title = conf[:graph_title];
      else
        ds.title = title
      end
      ds.linewidth = conf[:linewidth] 
      ds.title
    end
  end
  module_function :data_set  ;

  #
  # === errバーの追加
  #
  def data_set_with_err(plot, ds, x, y, conf, err)
    plot.data << Gnuplot::DataSet.new( [x,y, err] ) do |ds|
      ds.with = "yerrorbar ";  
      ds.title = conf[:err_title];
      # ds.linewidth = conf[:err_linewidth] 
      ds.linewidth =  0.2
    end  
  end
  module_function :data_set_with_err  ;

  #
  # === 直線の描画
  #
  def data_set_straight_line(plot,conf)
        x = Array.new ; 
        y = Array.new ; 
        10.times do |num|
          x.push(num) ;
          y.push(num) ;
        end
        plot.data << Gnuplot::DataSet.new( [x,y] ) do |ds|
          ds.with = "l"   #line＋point
          ds.title = conf[:graph_title_opt];
          ds.linewidth = conf[:linewidth2] 
        end
  
  end
  module_function :data_set_straight_line  ;

  #
  # === Hash(name1 => x, name2=> y)
  # @param data_lists Array[hash(一つのグラフ), hash]
  #
  def hashx_y(data_list, conf)
    Gnuplot.open do |gp|
      Gnuplot::Plot.new( gp ) do |plot|
        set_plot_conf(plot, conf) ;

          data_list.each do |data|
            x.push(data[0]) ;
            y.push(data[1]) ;
          end 
          data_set(plot, x, y, conf) ;

        data_set_straight_line(plot, conf) if conf[:is_straight_line] != nil
        plot.xrange conf[:x_range]  if conf[:x_range] != nil
        plot.yrange conf[:y_range]  if conf[:y_range] != nil
      end
    end
  end
  module_function :hashx_y  ;

  #
  # === Array Hash(name1 => x, name2=> y)
  # @param data_lists Array[hash(一つのグラフ), hash]
  #
  def list_hashx_y(data_lists, conf)
    Gnuplot.open do |gp|
      Gnuplot::Plot.new( gp ) do |plot|
        set_plot_conf(plot, conf) ;

        data_lists.each_with_index do |data_list, i|
          x = Array.new ;
          y = Array.new ;
          data_list.each do |data|
            x.push(data[0]) ;
            y.push(data[1]) ;
          end 
          data_set(plot,x, y, conf) ;
        end
        data_set_straight_line(plot,conf) if conf[:is_straight_line] != nil
        plot.xrange conf[:x_range]  if conf[:x_range] != nil
        plot.yrange conf[:y_range]  if conf[:y_range] != nil
      end
    end
  end
  module_function :list_hashx_y  ;

  #
  # === Array形式 arrayのサイズがx軸、要素がy軸
  # @param data_list Array 
  #
  def time_step(data_list, conf)
    Gnuplot.open do |gp|
      Gnuplot::Plot.new( gp ) do |plot|
        set_plot_conf(plot, conf) ;
        x =Array.new
        y = Array.new 
        err = Array.new
        data_list.each_with_index do |data, i|
            x.push(i)
            y.push(data)
          end
        data_set(plot, x, y, conf) ;
        data_set_with_err(plot, x, y, conf, err) if conf[:is_errbar]   #エラーバーがあれば

        plot.xrange conf[:x_range]  if conf[:x_range] != nil
        plot.yrange conf[:y_range]  if conf[:y_range] != nil
      end
    end
  end
  module_function :time_step  ;


  #
  # === 複数の Array形式 arrayのサイズがx軸、要素がy軸
  # @param data_list Array 
  #
  def list_time_step(data_list_list, conf)
    Gnuplot.open do |gp|
      Gnuplot::Plot.new( gp ) do |plot|
        set_plot_conf(plot, conf) ;
        data_list_list.each_with_index do |data_list, j|
          x =Array.new
          y = Array.new 
          err = Array.new
          data_list.each_with_index do |data, i|
            x.push(i)
            y.push(data)
          end
          data_set(plot, x, y, conf,conf[:graph_title][j]) ;
        end
        data_set_with_err(plot, x, y, conf, err) if conf[:is_errbar]   #エラーバーがあれば

        plot.xrange conf[:x_range]  if conf[:x_range] != nil
        plot.yrange conf[:y_range]  if conf[:y_range] != nil
      end
    end
  end
  module_function :list_time_step  ;
end
#
# 実行用
#
if($0 == __FILE__) then
  BasicTool.txtFileToArray(ARGV[0]) ;
end


