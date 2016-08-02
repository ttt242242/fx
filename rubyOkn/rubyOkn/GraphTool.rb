# -*- coding: utf-8 -*-

$LOAD_PATH.push(File::dirname($0)) ;
require "pry"
require "gnuplot"

#
# == 自分のrubyのグラフ周りのライブラリ
# yamlデータからグラフ作成
# Author::Takuya Okano
# Version::
# Date::
#
class GraphTool

  def self.create_graph(data_list, conf)
    setup(conf) ;

    case conf[:graph_pattern]
    when "1"
      create_graph_time_step(data_list, conf) ;
    when "2"
      create_graph_hash_hash(data_list, conf) ;
    when "3"
      create_graph_hash_hash(data_list, conf) ;
    end
  end

  #
  # === Array
  #
  def self.create_graph_time_step(data_list, conf)
    Gnuplot.open do |gp|
      Gnuplot::Plot.new( gp ) do |plot|
        plot.title conf[:g_title] if conf[:g_title] != nil
        plot.output conf[:save_folder]+conf[:title]+".eps"
        # plot.output conf[:title]+".eps"
        plot.ylabel conf[:ylabel]
        plot.xlabel conf[:xlabel]

        plot.set 'terminal postscript 16 eps enhanced color ' #必要epsで保存するには
        plot.set 'key '+conf[:hanreiPos]  #凡例の位置を調整
        # binding.pry ;
        # plot.set 'logscale'
        # plot.logscale 'x'

        plot.size conf[:plot_size] #"1,0.8"
        plot.origin conf[:origin] #"0.0, 0.0"
        plot.grid


        if conf[:is_errbar]   #エラーバーがあれば
          # x = (0..data_list.size-1).collect {|v| v.to_f}
          x =Array.new
          y = Array.new 
          err = Array.new
          data_list.each_with_index do |data, i|
            if i % conf[:err_scale] == 0
              if data.is_a?(Integer) || data.is_a?(Fixnum) || data.is_a?(Float)
              y.push(data)
            elsif data[:reward_stv_ave] != nil
              y.push(data[:reward_stv_ave])
            else
              y.push(data[:ave])
            end
            end
          end
          plot.data << Gnuplot::DataSet.new( [x,y] ) do |ds|
            ds.with = conf[:ds]   #line＋point
            ds.title = conf[:graph_title];
            ds.linewidth = conf[:linewidth] 
            ds.title
          end

          plot.data << Gnuplot::DataSet.new( [x,y, err] ) do |ds|
            ds.with = "yerrorbar ";  
            ds.title = conf[:err_title];
            # ds.linewidth = conf[:err_linewidth] 
            ds.linewidth =  0.2
          end
        else #エラーバーが必要ない時
          x =Array.new
          y = Array.new 
          err = Array.new
          data_list.each_with_index do |data, i|
            if i % conf[:scale] == 0
            x.push(i)

            #dataに入っている形式が異なるので分岐
            if data.is_a?(Integer) || data.is_a?(Fixnum) || data.is_a?(Float)
              y.push(data)
            elsif data[:reward_stv_ave] != nil
              y.push(data[:reward_stv_ave])
            else
              y.push(data[:ave])
            end
            # y.push(data[:ave])
            # y.push(data[:reward_stv_ave])
            # err.push(data[:std])
            end
          end
          plot.data << Gnuplot::DataSet.new( [x,y] ) do |ds|
            ds.with = conf[:ds]   #line＋point
            ds.title = conf[:graph_title];
            ds.linewidth = conf[:linewidth] 
            ds.title
          end


        end

        # plot.xrange conf["x_range"]
        # plot.yrange conf["y_range"]
      end
    end

  end

  #
  # === Array 縦軸が２つあるグラフ タイムステップ毎の
  #
  def self.create_graph_time_step_2y_axis(data_list, conf)
    Gnuplot.open do |gp|
      Gnuplot::Plot.new( gp ) do |plot|
        plot.title conf[:g_title] if conf[:g_title] != nil
        plot.output conf[:save_folder]+conf[:title]+".eps"
        # plot.output conf[:title]+".eps"
        plot.ylabel conf[:ylabel]
        plot.y2label conf[:y2label]
        plot.xlabel conf[:xlabel]

        plot.set 'terminal postscript 16 eps enhanced color ' #必要epsで保存するには
        plot.set 'key '+conf[:hanreiPos]  #凡例の位置を調整
        plot.set 'ytics nomirror'
        plot.set 'y2tics'
        plot.size conf[:size] if conf[:size] != nil
        # binding.pry ;
        # plot.set 'logscale'
        # plot.logscale 'x'

        plot.size conf[:plot_size] #"1,0.8"
        plot.origin conf[:origin] #"0.0, 0.0"
        plot.grid


        if conf[:is_errbar]   #エラーバーがあれば
          # x = (0..data_list.size-1).collect {|v| v.to_f}
          x =Array.new
          y = Array.new 
          err = Array.new
          data_list.each_with_index do |data, i|
            if i % conf[:err_scale] == 0
             if data.is_a?(Integer) || data.is_a?(Fixnum) || data.is_a?(Float)
              y.push(data)
            elsif data[:reward_stv_ave] != nil
              y.push(data[:reward_stv_ave])
            else
              y.push(data[:ave])
            end
            end
          end
          plot.data << Gnuplot::DataSet.new( [x,y] ) do |ds|
            ds.with = conf[:ds]   #line＋point
            ds.title = conf[:graph_title];
            ds.linewidth = conf[:linewidth] 
            ds.title
          end

          plot.data << Gnuplot::DataSet.new( [x,y, err] ) do |ds|
            ds.with = "yerrorbar ";  
            ds.title = conf[:err_title];
            # ds.linewidth = conf[:err_linewidth] 
            ds.linewidth =  0.2
          end
        else #エラーバーが必要ない時
          x =Array.new
          y = Array.new 
          err = Array.new
          data_list[0].each_with_index do |data, i|
            if i % conf[:scale] == 0
            x.push(i)
            #dataに入っている形式が異なるので分岐
            if data.is_a?(Integer) || data.is_a?(Fixnum) || data.is_a?(Float)
              y.push(data)
            elsif data[:reward_stv_ave] != nil
              y.push(data[:reward_stv_ave])
            else
              y.push(data[:ave])
            end
            # y.push(data[:ave])
            # y.push(data[:reward_stv_ave])
            # err.push(data[:std])
            end
          end
          plot.data << Gnuplot::DataSet.new( [x,y] ) do |ds|
            ds.with = conf[:ds]   #line＋point
            ds.title = conf[:graph_title];
            ds.linewidth = conf[:linewidth] 
            ds.title
          end

          x =Array.new
          y = Array.new 
          err = Array.new
          data_list[1].each_with_index do |data, i|
            if i % conf[:scale] == 0
            x.push(i)
            #dataに入っている形式が異なるので分岐
            # if data[:ave] != nil
            if data.is_a?(Integer) || data.is_a?(Fixnum) || data.is_a?(Float)
              y.push(data)
            elsif data[:reward_stv_ave] != nil
              y.push(data[:reward_stv_ave])
            else
              y.push(data[:ave])
            end
            # y.push(data[:ave])
            # y.push(data[:reward_stv_ave])
            # err.push(data[:std])
            end
          end
          plot.data << Gnuplot::DataSet.new( [x,y] ) do |ds|
            ds.with = conf[:ds]+" axes x1y2"   #line＋point
            ds.title = conf[:graph_title];
            ds.linewidth = conf[:linewidth] 
            ds.title
          end


        end

        # plot.xrange conf["x_range"]
        plot.yrange conf["y_range"] if conf["y_range"] != nil
        plot.y2range conf["y2_range"] if conf["y2_range"] != nil
      end
    end

  end





  #
  # === Array
  #
  def self.create_graph_time_step_bar(data_list, conf)
    Gnuplot.open do |gp|
      Gnuplot::Plot.new( gp ) do |plot|
        plot.title conf[:g_title] if conf[:g_title] != nil
        plot.output conf[:save_folder]+conf[:title]+".eps"
        # plot.output conf[:title]+".eps"
        plot.ylabel conf[:ylabel]
        plot.xlabel conf[:xlabel]

        plot.set 'terminal postscript 16 eps enhanced color ' #必要epsで保存するには
        plot.set 'key '+conf[:hanreiPos]  #凡例の位置を調整
        # binding.pry ;
        # plot.set 'logscale'
        # plot.logscale 'x'
        # plot.set "style fill solid border lc rgb 'black'"
        plot.size conf[:plot_size] #"1,0.8"
        plot.origin conf[:origin] #"0.0, 0.0"
        plot.grid


        if conf[:is_errbar]   #エラーバーがあれば
          # x = (0..data_list.size-1).collect {|v| v.to_f}
          x =Array.new
          y = Array.new 
          err = Array.new
          data_list.each_with_index do |data, i|
            if i % conf[:err_scale] == 0
              x.push(i)
              y.push(data[:ave])
              err.push(data[:stv])
            end
          end
          plot.data << Gnuplot::DataSet.new( [x,y] ) do |ds|
            ds.with = conf[:ds]   #line＋point
            ds.title = conf[:graph_title];
            ds.linewidth = conf[:linewidth] 
            ds.title
          end

          plot.data << Gnuplot::DataSet.new( [x,y, err] ) do |ds|
            ds.with = "yerrorbar ";  
            ds.title = conf[:err_title];
            # ds.linewidth = conf[:err_linewidth] 
            ds.linewidth =  0.2
          end
        else #エラーバーが必要ない時
          x =Array.new
          y = Array.new 
          err = Array.new
          data_list.each_with_index do |data, i|
            x.push(data[0])
            # y.push(data[:ave])
            y.push(data[1])
            # err.push(data[:std])
          end
          plot.data << Gnuplot::DataSet.new( [x,y] ) do |ds|
            ds.with = conf[:ds]   #line＋point
            # ds.with = "p"   #line＋point
            ds.title = conf[:graph_title];
            ds.linewidth = conf[:linewidth] 
            ds.title
          end


        end

        plot.xrange conf["x_range"]  if conf["x_range"] != nil
        plot.yrange conf["y_range"]  if conf["y_range"] != nil
      end
    end

  end

  #
  # === Array
  #
  def self.create_graph_time_step_list(data_list, conf)
    Gnuplot.open do |gp|
      Gnuplot::Plot.new( gp ) do |plot|
        # plot.output conf[:save_folder]+conf[:title]+".eps"
        plot.title conf[:g_title] if conf[:g_title] != nil
        plot.output conf[:title]+".eps"
        plot.ylabel conf[:ylabel]
        plot.xlabel conf[:xlabel]



        plot.set 'terminal postscript 16 eps enhanced color ' #必要epsで保存するには
        plot.set 'key '+conf[:hanreiPos]  #凡例の位置を調整


        # binding.pry ;
        # plot.set 'logscale'
        # plot.logscale 'x'

        plot.size conf[:plot_size] #"1,0.8"
        plot.origin conf[:origin] #"0.0, 0.0"
        plot.grid
        data_list.each_with_index do |d, i|
          # x = (0..d.size-1).collect {|v| v.to_f}
          x = Array.new ;
          y = Array.new 
          err = Array.new
          d.each_with_index do |data, j|
            if j % conf[:scale] == 0
            x.push(j) ;
            y.push(data[:ave])
            # err.push(data[:stv])
            # y.push(data[key][:ave])
            # err.push(data[key][:stv])
             end
          end

          plot.data << Gnuplot::DataSet.new( [x,y] ) do |ds|
            ds.with = conf[:ds]+conf[:ls][i]  #line＋point
            ds.title = conf[:graph_title2][i];
            ds.linewidth = conf[:linewidth] 
            ds.title
          end

          if conf[:is_errbar]   #エラーバーがあれば
            plot.data << Gnuplot::DataSet.new( [x,y, err] ) do |ds|
              ds.with = conf[:ds]   #line＋point
              ds.title = conf[:graph_title];
              ds.linewidth = conf[:linewidth] 
              ds.title
            end
          end
        end
        # plot.xrange conf["x_range"]
        # plot.yrange conf["y_range"]
      end
    end

  end
  #
  # === Hash(name1 => x, name2=> y)
  #
  def self.create_graph_hash_hash2(data_lists, conf)
    Gnuplot.open do |gp|
      Gnuplot::Plot.new( gp ) do |plot|
        # plot.output conf[:save_folder]+conf[:title]+".eps"
        plot.output conf[:title]+".eps"
        plot.ylabel conf[:ylabel]
        plot.xlabel conf[:xlabel]

        plot.set 'terminal postscript 16 eps enhanced color ' #必要epsで保存するには
        plot.set 'key '+conf[:hanreiPos]  #凡例の位置を調整
        # plot.set 'key '+conf[:hanreiPos]  #凡例の位置を調整
        # plot.set 'logscale'
        # plot.logscale 'x'

        plot.size conf[:plot_size] #"1,0.8"
        # plot.size "1,0.8"
        plot.origin conf[:origin] #"0.0, 0.0"
        plot.grid

        data_lists.each_with_index do |data_list, i|
          x = Array.new ;
          y = Array.new ;

          data_list.each do |data|
            x.push(data[data.keys[0]]) ;
            # x.push(data[0]) ;
            # keys = data[data.keys[0]].keys ;
            # y.push(data[data.keys[0]][keys[0]]) ;
            y.push(data[data.keys[1]]) ;
            # y.push(data[1]) ;
          end 
          plot.data << Gnuplot::DataSet.new( [x,y] ) do |ds|
            # ds.with = conf[:ds]+conf[:ls]   #line＋point
            # ds.with = conf[:ds]   #line＋point
            ds.with = "lp"
            # ds.title = conf[:graph_title][i];
            ds.title = "test"
            ds.linewidth = conf[:linewidth] 
          end
        end

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
        #最適値があれば、出力する
        #     if conf[:is_optimum]
        #       x = Array.new ;
        #       y = Array.new ;
        #       data_list.each do |data|
        #        x.push(data.keys[0]) ;
        #        y.push(conf[:optimum_value]) ;
        #     end 
        #     plot.data << Gnuplot::DataSet.new( [x,y] ) do |ds|
        #       ds.with = conf[:ds]   #line＋point
        #       ds.title = "optimum";
        #       ds.linewidth = 1
        #     end
        #
        #     end
        #
        #     if conf[:is_errbar]     #エラーバーを表示する必要あれば
        #       x = Array.new ;
        #       err = Array.new ;
        #       data_list.each_with_index do |data, i|
        #
        #         x.push(data.keys[0]) ;
        #         if data.keys[0] > 1.0 
        #           if data.keys[0] % conf[:err_scale] == 0.0
        #             keys = data[data.keys[0]].keys ;
        #             err.push(data[data.keys[0]][keys[1]]) ;
        #           else
        #             err.push(0) ;
        #           end
        #         else
        #           keys = data[data.keys[0]].keys ;
        #           err.push(data[data.keys[0]][keys[1]]) ;
        #         end
        #       end 
        #       plot.data << Gnuplot::DataSet.new( [x,y, err] ) do |ds|
        #         ds.with = "yerrorbar ";  
        #         ds.title = conf[:err_title];
        #         ds.linewidth = conf[:err_linewidth] 
        #       end
        #     end
        #
        plot.xrange conf["x_range"]  if conf["x_range"] != nil
        # plot.xrange "[0:1]" 
        plot.yrange conf["y_range"]  if conf["y_range"] != nil
      end

    end

  end


  #
  # === Hash(x => (y1, y2))
  #
  def self.create_graph_hash_hash(data_list, conf)
    Gnuplot.open do |gp|
      Gnuplot::Plot.new( gp ) do |plot|
        plot.title conf[:g_title] if conf[:g_title] != nil
        plot.output conf[:save_folder]+conf[:title]+".eps"
        plot.ylabel conf[:ylabel]
        plot.xlabel conf[:xlabel]

        plot.set 'terminal postscript 16 eps enhanced color ' #必要epsで保存するには
        plot.set 'key '+conf[:hanreiPos]  #凡例の位置を調整
        # binding.pry ;
        # plot.set 'logscale'
        # plot.logscale 'x'

        plot.size conf[:plot_size] #"1,0.8"
        # plot.size "1,0.8"
        plot.origin conf[:origin] #"0.0, 0.0"
        plot.grid

        ##
        if conf[:is_errbar]     #エラーバーを表示する必要あれば
          x = Array.new ;
          y = Array.new ;
          err = Array.new ;
          data_list.each_with_index do |data, i|
            if i % conf[:err_scale] == 0.0
              x.push(data.keys[0]) ;
              keys = data[data.keys[0]].keys ;
              y.push(data[data.keys[0]][keys[0]]) ;
              # err.push(data[data.keys[0]][keys[1]]) ;
              err.push(data[:ep_std]) ;
              # err.push(data[data.keys[0]][keys[2]]) ;
            end 
          end
          plot.data << Gnuplot::DataSet.new( [x,y] ) do |ds|
            ds.with = conf[:ds]   #line＋point
            ds.title = conf[:graph_title];
            ds.linewidth = conf[:linewidth] 
          end

          plot.data << Gnuplot::DataSet.new( [x,y, err] ) do |ds|
            ds.with = "yerrorbar ";  
            ds.title = conf[:err_title];
            # ds.linewidth = conf[:err_linewidth] 
            ds.linewidth =  0.2
          end

        else #エラーバーがいらなければ
          ###
          x = Array.new ;
          y = Array.new ;
          data_list.each do |data|
            x.push(data.keys[0]) ;
            keys = data[data.keys[0]].keys ;
            y.push(data[data.keys[0]][keys[0]]) ;
          end 
          plot.data << Gnuplot::DataSet.new( [x,y] ) do |ds|
            ds.with = conf[:ds]   #line＋point
            ds.title = conf[:graph_title];
            ds.linewidth = conf[:linewidth] 
          end
        end


        #最適値があれば、出力する
        if conf[:is_optimum]
          x = Array.new ;
          y = Array.new ;
          data_list.each do |data|
            x.push(data.keys[0]) ;
            y.push(conf[:optimum_value]) ;
          end 
          plot.data << Gnuplot::DataSet.new( [x,y] ) do |ds|
            ds.with = conf[:ds]   #line＋point
            ds.title = "optimum";
            ds.linewidth = 1
          end

        end

        plot.xrange conf["x_range"]  if conf["x_range"] != nil
        plot.yrange conf["y_range"]  if conf["y_range"] != nil
      end
    end

  end

  #
  # === Hash(x => (y1, y2))
  #
  def self.create_graph_hash_hash_test(data_list, conf)
    Gnuplot.open do |gp|
      Gnuplot::Plot.new( gp ) do |plot|
        # plot.output conf[:save_folder]+conf[:title]+".eps"
        # plot.output "kkkkkkkkkkkkkk.eps"
        plot.output conf[:save_folder]+conf[:title]+".eps"
        plot.ylabel conf[:ylabel]
        plot.xlabel conf[:xlabel]

        plot.set 'terminal postscript 16 eps enhanced color ' #必要epsで保存するには
        plot.set 'key '+conf[:hanreiPos]  #凡例の位置を調整
        # plot.set 'autoscale'
        # binding.pry ;
        # plot.set 'logscale'
        plot.logscale 'x'

        plot.size conf[:plot_size] #"1,0.8"
        # plot.size "1,0.8"
        plot.origin conf[:origin] #"0.0, 0.0"
        plot.grid

        x = Array.new ;
        y = Array.new ;
        data_list.each do |data|
          x.push(data[0]) ;
          y.push(data[1]) ;
        end 
        plot.data << Gnuplot::DataSet.new( [x,y] ) do |ds|
          ds.with = conf[:ds]   #line＋point
          ds.title = conf[:graph_title];
          ds.linewidth = conf[:linewidth] 
        end

        if conf[:is_errbar]     #エラーバーを表示する必要あれば
          x = Array.new ;
          y = Array.new ;
          err = Array.new ;
          data_list.each_with_index do |data, i|
            if i % conf[:err_scale] == 0.0
              x.push(data.keys[0]) ;
              keys = data[data.keys[0]].keys ;
              y.push(data[data.keys[0]][keys[0]]) ;
              # err.push(data[data.keys[0]][keys[1]]) ;
              err.push(data[:ep_std]) ;
              # err.push(data[data.keys[0]][keys[2]]) ;
            end 
          end
          plot.data << Gnuplot::DataSet.new( [x,y] ) do |ds|
            ds.with = conf[:ds]   #line＋point
            ds.title = conf[:graph_title];
            ds.linewidth = conf[:linewidth] 
          end

          plot.data << Gnuplot::DataSet.new( [x,y, err] ) do |ds|
            ds.with = "yerrorbar ";  
            ds.title = conf[:err_title];
            # ds.linewidth = conf[:err_linewidth] 
            ds.linewidth =  0.2
          end

        end
      end

    end
end

  #
  # === 棒グラフ表示
  # bar_list array [{:ave=> , :std=>}, ]
  #
  #
  def self.create_bar_graph(bar_list, conf)
    Gnuplot.open do |gp|
      Gnuplot::Plot.new( gp ) do |plot|
        plot.title conf[:g_title] if conf[:g_title] != nil
        # plot.output conf[:save_folder]+conf[:title]+".eps"
        plot.output conf[:title]+".eps"
        plot.ylabel conf[:ylabel]
        plot.xlabel conf[:xlabel]

        plot.set 'terminal postscript 16 eps enhanced color ' #必要epsで保存するには

        plot.set 'style fill solid border lc rgb "black" '
        plot.set 'boxwidth 1.0 '

        plot.set 'xtics ("WoUE" 1, "MAER" 3)'
        plot.set 'key '+conf[:hanreiPos]  #凡例の位置を調整

        # binding.pry ;
        # plot.set 'logscale'
        # plot.logscale 'x'

        plot.size conf[:plot_size] #"1,0.8"
        # plot.size "1,0.8"
        plot.origin conf[:origin] #"0.0, 0.0"
        plot.grid
       
        y = Array.new  ;
        x = Array.new  ;
        err = Array.new ;
        x = [1,3] 
        bar_list.each_with_index do |data, i|
          y.push(data[:ave])   ;
          err.push( data[:std] ) ;
        end 
        ##
        if conf[:is_errbar]     #エラーバーを表示する必要あれば
          plot.data << Gnuplot::DataSet.new( [x,y] ) do |ds|
            ds.with = "boxes"   #line＋point
            ds.title = conf[:graph_title];
            # ds.linewidth = conf[:linewidth] 
            ds.notitle ;
          end

          plot.data << Gnuplot::DataSet.new( [x,y, err] ) do |ds|
            ds.with = "yerrorbar ";  
            # ds.title = conf[:err_title];
            # ds.linewidth = conf[:err_linewidth] 
            ds.notitle ;
            ds.linewidth = 1.0  ;
          end

        else #エラーバーがいらなければ
          
          plot.data << Gnuplot::DataSet.new( [x_array,y_array] ) do |ds|
            # ds.with = conf[:ds]   #line＋point
            ds.with = "p"   #line＋point
            ds.title = conf[:graph_title2];
            ds.linewidth = conf[:linewidth] 
          end
        end


        
        plot.xrange conf["x_range"]  if conf["x_range"] != nil
        plot.yrange conf["y_range"]  if conf["y_range"] != nil
      end
    end

  end


  #
  # === 散布図を表示
  # x_array array 
  # y_array array 
  #
  def self.scatter_graph(x_array, y_array, conf)
    Gnuplot.open do |gp|
      Gnuplot::Plot.new( gp ) do |plot|
        plot.title conf[:g_title] if conf[:g_title] != nil
        # plot.output conf[:save_folder]+conf[:title]+".eps"
        plot.output conf[:title]+".eps"
        plot.ylabel conf[:ylabel]
        plot.xlabel conf[:xlabel]

        plot.set 'terminal postscript 16 eps enhanced color ' #必要epsで保存するには
        plot.set 'key '+conf[:hanreiPos]  #凡例の位置を調整
        # binding.pry ;
        # plot.set 'logscale'
        # plot.logscale 'x'

        plot.size conf[:plot_size] #"1,0.8"
        # plot.size "1,0.8"
        plot.origin conf[:origin] #"0.0, 0.0"
        plot.grid

        ##
        if conf[:is_errbar]     #エラーバーを表示する必要あれば
          err = [] ;
          plot.data << Gnuplot::DataSet.new( [x_array,y_array] ) do |ds|
            ds.with = conf[:ds]   #line＋point
            ds.title = conf[:graph_title];
            ds.linewidth = conf[:linewidth] 
          end

          plot.data << Gnuplot::DataSet.new( [x_array,y_array, err] ) do |ds|
            ds.with = "yerrorbar ";  
            ds.title = conf[:err_title];
            # ds.linewidth = conf[:err_linewidth] 
            ds.linewidth =  0.2
          end

        else #エラーバーがいらなければ
          
          plot.data << Gnuplot::DataSet.new( [x_array,y_array] ) do |ds|
            # ds.with = conf[:ds]   #line＋point
            ds.with = "p"   #line＋point
            ds.title = conf[:graph_title2];
            ds.linewidth = conf[:linewidth] 
          end
        end


        #最適値があれば、出力する
        if conf[:is_optimum]
          x = Array.new ;
          y = Array.new ;
          20.times do |num|
            x.push(num)
            y.push(num)
          end

            plot.data << Gnuplot::DataSet.new( [x,y] ) do |ds|
            ds.with = "l"   #line＋point
            ds.title = "optimum";
            ds.linewidth = 1
          end

        end

        plot.xrange conf["x_range"]  if conf["x_range"] != nil
        plot.yrange conf["y_range"]  if conf["y_range"] != nil
      end
    end

  end

  #
  # === 様々な設定での散布図を表示
  # x_array array 
  # y_array array 
  #
  def self.scatter_graph_list(graph_list, conf)
    Gnuplot.open do |gp|
      Gnuplot::Plot.new( gp ) do |plot|
        plot.title conf[:g_title] if conf[:g_title] != nil
        # plot.output conf[:save_folder]+conf[:title]+".eps"
        plot.output conf[:title]+".eps"
        plot.ylabel conf[:ylabel]
        plot.xlabel conf[:xlabel]

        plot.set 'terminal postscript 16 eps enhanced color ' #必要epsで保存するには
        plot.set 'key '+conf[:hanreiPos]  #凡例の位置を調整
        # binding.pry ;
        # plot.set 'logscale'
        # plot.logscale 'x'

        plot.size conf[:plot_size] #"1,0.8"
        # plot.size "1,0.8"
        plot.origin conf[:origin] #"0.0, 0.0"
        plot.grid

        ##
        if conf[:is_errbar]     #エラーバーを表示する必要あれば
          err = [] ;
          plot.data << Gnuplot::DataSet.new( [x_array,y_array] ) do |ds|
            ds.with = conf[:ds]   #line＋point
            ds.title = conf[:graph_title];
            ds.linewidth = conf[:linewidth] 
          end

          plot.data << Gnuplot::DataSet.new( [x_array,y_array, err] ) do |ds|
            ds.with = "yerrorbar ";  
            ds.title = conf[:err_title];
            # ds.linewidth = conf[:err_linewidth] 
            ds.linewidth =  0.2
          end

        else #エラーバーがいらなければ
         
         graph_list.each_with_index do |data, i|
           x_array = data[:x_array] ;
           y_array = data[:y_array] ;
          plot.data << Gnuplot::DataSet.new( [x_array,y_array] ) do |ds|
            # ds.with = conf[:ds]   #line＋point
            ds.with = "p"   #line＋point
            ds.title = conf[:graph_title2][i];
            ds.linewidth = conf[:linewidth] 
          end
         end
        end

        #最適値があれば、出力する
        if conf[:is_optimum]
          x = Array.new ;
          y = Array.new ;
          20.times do |num|
            x.push(num)
            y.push(num)
          end

            plot.data << Gnuplot::DataSet.new( [x,y] ) do |ds|
            ds.with = "l"   #line＋point
            # ds.title = "optimum";
            ds.title = "woue = evo";
            ds.linewidth = 1
          end

        end

        plot.xrange conf["x_range"]  if conf["x_range"] != nil
        plot.yrange conf["y_range"]  if conf["y_range"] != nil
      end
    end

  end


    #
    # === 複数のHash(x => (y1, y2))データをグラフ化
    #
  def self.create_graph_hash_hash_list(data_list_list, conf)
    Gnuplot.open do |gp|
      Gnuplot::Plot.new( gp ) do |plot|

        plot.title conf[:g_title] if conf[:g_title] != nil
        plot.output conf[:title]+".eps"
        plot.ylabel conf[:ylabel]
        plot.xlabel conf[:xlabel]

        # plot.set 'boxwidth 0.5'
        plot.set 'terminal postscript 16 eps enhanced color ' #必要epsで保存するには
        plot.set 'key '+conf[:hanreiPos]  #凡例の位置を調整
        plot.set 'xtics '+conf[:mxtics] if conf[:mxtics] !=nil
        plot.size conf[:plot_size] #"1,0.8"
        plot.origin conf[:origin] #"0.0, 0.0"
        plot.grid

        # plot.set 'xtics ("WoUE")'
        # plot.set 'autoscale'
        # plot.set 'xtics 20000'
        # plot.set 'logscale y' if conf[:is_ylogscale]
        if conf[:is_errbar]     #エラーバーを表示する必要あれば
          data_list_list.each_with_index do |data_list,i| 
            x = Array.new ;
            y = Array.new ;
            err =Array.new ;
            data_list.each do |data|
              if data.keys[0] % conf[:err_scale] == 0.0
                x.push(data.keys[0]) ;
                keys = data[data.keys[0]].keys ;
                y.push(data[data.keys[0]][keys[0]]) ;
                # err.push(data[data.keys[0]][keys[1]]) ;
                err.push(data[:ep_std]) ;
              end
            end 
            plot.data << Gnuplot::DataSet.new( [x,y] ) do |ds|
              ds.with = conf[:ds]   #line＋point
              ds.title = conf[:graph_title][i];
              ds.linewidth = conf[:linewidth][i]
            end

            plot.data << Gnuplot::DataSet.new( [x,y, err] ) do |ds|
              ds.with = "yerrorbar ";  
              ds.title = conf[:err_title];
              # ds.linewidth = conf[:err_linewidth] 
              ds.linewidth =  0.2
            end
          end
        plot.xrange conf["x_range"]  if conf["x_range"] != nil
        plot.yrange conf["y_range"]  if conf["y_range"] != nil
      else
        data_list_list.each_with_index do |data_list,i| 
          x = Array.new ;
          y = Array.new ;
          data_list.each_with_index do |data, j|
            if conf[:graph_name] == "create_graphs_epsilon_timestep_ave"
              if j % 2 == 0
                if j % conf[:scale] == 0 
                  keys = data[data.keys[0]].keys ;
                  if data[data.keys[0]][keys[0]] != nil
                    x.push(data.keys[0]) ;
                    # x.push(data.keys[0]/2.0) ;
                    y.push(data[data.keys[0]][keys[0]]) ;
                  end
                else
                  if j % conf[:scale] == 0 
                    x.push(data.keys[0]) ;
                    # x.push(data.keys[0]/2.0) ;
                    keys = data[data.keys[0]].keys ;
                    y.push(data[data.keys[0]][keys[0]]) ;
                  end
                end
              end
            else
              if j % conf[:scale] == 0 
                    x.push(data.keys[0]) ;
                    # x.push(data.keys[0]/2.0) ;
                    keys = data[data.keys[0]].keys ;
                    y.push(data[data.keys[0]][keys[0]]) ;
                  end

            end
          end 
          plot.data << Gnuplot::DataSet.new( [x,y] ) do |ds|
            ds.with = conf[:ds]   #line＋point
            ds.title = conf[:graph_title][i];
            ds.linewidth = conf[:linewidth][i] 
          end
        end
        plot.xrange conf["x_range"]  if conf["x_range"] != nil
        plot.yrange conf["y_range"]  if conf["y_range"] != nil
      end
    end
  end
end
  end
#
# 実行用
#
if($0 == __FILE__) then
  BasicTool.txtFileToArray(ARGV[0]) ;
end


