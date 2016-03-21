# -*- coding: utf-8 -*-

$LOAD_PATH.push(File::dirname($0)) ;
require "pry"
require "yaml"
require "gnuplot"
require "BasicTool"


include BasicTool ;

# data = YAML.load_file("agent_dataEnum_0.yml") ;
Gnuplot.open do |gp|
  Gnuplot::Plot.new( gp ) do |plot|


    plot.output "reward_fun.eps"
    # plot.output "../sqrt2.eps"
    plot.set 'terminal postscript 16 eps enhanced color ' #必要epsで保存するには
    plot.set 'style fill solid border lc rgb "black" '
    plot.set 'boxwidth 1.0 '
    plot.size "1,0.8"
    plot.origin "0.0, 0.0"
    plot.xlabel "test"
    plot.set 'xtics ("one" 1, "two" 3)'
    plot.grid
    # x = (0..50).collect {|v| v.to_f}
    c = 6.0 ;
    array = [40, 20] 
    array2 = [1,3] 
    i = 1.0 ;
    
     
    plot.data << Gnuplot::DataSet.new( [array2, array] ) do |ds|
      # ds.using "1:2"
      ds.with = "boxes "    #line＋point
      ds.linewidth =1 
      # ds.title = "sqrt" ;
      ds.notitle ;
    end

    plot.yrange "[0:50]"
    ############################################
   end
end


