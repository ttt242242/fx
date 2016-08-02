#!/usr/bin/ruby
# -*- encoding: utf-8 -*-



$LOAD_PATH.push(File::dirname($0)) ;
require "pry"
require "yaml"
require "Object"
require 'rubyOkn/BasicTool'

include BasicTool

#
# == 基礎的なエージェントクラス
#
class BaseAgent < Object
  attr_accessor :average_reward, :a, :q_table , :e;
  def initialize(agent_conf = nil)
    super() ;
    @average_reward = 0.0 ;
    @id = agent_conf[:id] ;
    # @e = agentConf[:e] ;
    @a =agent_conf[:a] ;
    @e =agent_conf[:e] ;
    # @averageReward =agent_conf[:average_reward] ;
  end


  def get_q_by_id()
    raise 'Called abstract method !'
  end

  # 
  # === 自身の期待報酬テーブルの更新
  #
  # def update_q_table(reward, action, q_id = nil)
  #   raise 'Called abstract method !'
  # end
  #
  
  #
  # === 平均報酬の更新
  #
  def calc_average_reward(reward, cycle)
    @averageReward = (cycle.to_f/(cycle.to_f+1.0))*@averageReward + (1.0/(cycle.to_f+1.0))* reward ;
  end

end

#
# 実行用
#
if($0 == __FILE__) then
  
end


