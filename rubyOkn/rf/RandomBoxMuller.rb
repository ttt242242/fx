# -*- coding: utf-8 -*-
#
$LOAD_PATH.push(File::dirname($0)) ;
require "pry"
#*********************************************
# ボックス＝ミューラー法法による正規乱数生成
#*********************************************
class RndnumBoxMuller
  # 各種定数
  M  = 50            # 平均
  S  = 10           # 標準偏差
  N  = 200         # 発生させる乱数の個数
  PI = 3.1415926535  # 円周率
  SCALE = N / 200.0  # ヒストグラム用スケール

  # 計算クラス
  class Calc
    # コンストラクタ
    def initialize
      # 件数格納用配列初期化
      @hist = Array.new( M * 5, 0 )
    end

    # 正規乱数生成
    def generate_rndnum
      # N 回乱数生成処理を繰り返す
      0.upto( N - 1 ) do |i|
        # 整数乱数を２個生成
        res = rnd

        # 整数乱数をカウント
        @hist[res[0]] += 1
        @hist[res[1]] += 1
      end
    end

    # 整数乱数
    def rnd
      # 一様乱数
      # ( (0,1] の実数乱数 )
      r_1 = rand
      r_2 = rand

      # 正規乱数計算
      x = S * Math.sqrt(-2 * Math.log(r_1)) * Math.cos(2 * PI * r_2) + M
      y = S * Math.sqrt(-2 * Math.log(r_1)) * Math.sin(2 * PI * r_2) + M

      # ２個の正規乱数を整数化して配列でリターン
      return [ x.to_i, y.to_i ]
    end

    # 結果表示
    def display
      # 0 ～ M * 2 を表示
      0.upto( M * 2 ) do |i|
        # 件数表示
        printf("%3d:%4d | ", i, @hist[i])

        # ヒストグラム表示
        1.upto( @hist[i] / SCALE ) { |j| print "*" }
        puts
      end
    end
  end

  # メイン処理
  begin
    # 計算クラスインスタンス化
    obj_calc = Calc.new

    # 正規乱数生成
    obj_calc.generate_rndnum

    # 結果表示
    obj_calc.display
  rescue => e
    # エラーメッセージ
    puts "[例外発生] #{e}"
  end
end



