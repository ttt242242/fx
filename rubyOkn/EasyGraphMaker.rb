# -*- coding: utf-8 -*-

$LOAD_PATH.push(File::dirname($0)) ;
require "pry"
require "gnuplot"




Gnuplot.open do |gp|
  Gnuplot::Plot.new( gp ) do |plot|


    plot.output "test.eps"
        plot.set 'terminal postscript 16 eps enhanced color ' #必要epsで保存するには
    plot.size "1,0.8"
    plot.origin "0.0, 0.0"
    plot.grid
    x = (0..50).collect {|v| v.to_f}
    c = 10.0 ;
    array = Array.new 
    array2 = Array.new 
    x.each do  |x1|
      # y = (1.0/(1.0+x1/35.0)) ;
      # y = (1.0/(1.0+x1/5.0)) ;
      y = x1 * Math.exp(-x1/c) ;
      array.push(y) ;
      if x1 <= c 
        y = x1
      else
        y = c * Math.exp(-x1/c) ;
      end
      array2.push(y) ;
    end
    plot.data << Gnuplot::DataSet.new( [x,array] ) do |ds|
      ds.with = "lp"   #line＋point
      ds.linewidth =1 
      ds.title = "test" ;
    end
    plot.data << Gnuplot::DataSet.new( [x,array2] ) do |ds|
      ds.with = "lp"   #line＋point
      ds.linewidth =1 
      ds.title
    end
  end
end


