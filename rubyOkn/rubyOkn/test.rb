
#!/usr/bin/ruby
# -*- encoding: utf-8 -*-



$LOAD_PATH.push(File::dirname($0)) ;
require "pry"
require "yaml"
require 'MathTool'
require 'BasicTool'
require 'GenerateGraph'

include MathTool
array = []

hash = {}
100000.times do 
  t = GenerateRand.exp(0.02).round(2)
if hash[t]== nil  
  hash[t] = 0 ;
else
  hash[t] +=1 ;
end
end
hash = hash.sort
array.push(hash)

hash = {}
100000.times do 
  t = GenerateRand.exp(0.04).round(2)
if hash[t]== nil  
  hash[t] = 0 ;
else
  hash[t] +=1 ;
end
end

hash = hash.sort
array.push(hash)

hash = {}
100000.times do 
  t = GenerateRand.exp(0.07).round(2)
if hash[t]== nil  
  hash[t] = 0 ;
else
  hash[t] +=1 ;
end
end

hash = hash.sort
array.push(hash)

hash = {}
100000.times do 
  t = GenerateRand.exp(0.1).round(2)
if hash[t]== nil  
  hash[t] = 0 ;
else
  hash[t] +=1 ;
end
end

hash = hash.sort
array.push(hash)
hash = {}
100000.times do 
  t = GenerateRand.exp(0.5).round(2)
if hash[t]== nil  
  hash[t] = 0 ;
else
  hash[t] +=1 ;
end
end

conf = {}
conf[:title] = "ttt"

hash = hash.sort
array.push(hash)
conf = GenerateGraph.make_default_conf()
GenerateGraph.list_hashx_y(array, conf)
