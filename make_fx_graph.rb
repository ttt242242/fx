#!/usr/bin/ruby
# -*- encoding: utf-8 -*-

$LOAD_PATH.push(File::dirname($0)) ;
require "pry"
require "yaml"
require 'rubyOkn/BasicTool'
require 'rubyOkn/GenerateGraph'

include BasicTool
include GenerateGraph;


result_data = YAML.load_file("/home/okano/MEGA/fx_data.yml") ;

graph_data = [] ;
result_data.each do |d|
  graph_data.push(d[:err_previous]) ;
end

conf = make_default_conf("/home/okano/MEGA/fx_graph") ;
time_step(graph_data, conf) ;

