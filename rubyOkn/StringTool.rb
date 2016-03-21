# -*- coding: utf-8 -*-

$LOAD_PATH.push(File::dirname($0)) ;
require "pry"
require "yaml"
require "csv"
require "narray"
require 'MeCab'
# require "marshal"

#
# == 自分のrubyライブラリ
#文章関係の処理を行うライブラリ
# Author::Takuya Okano
# Version::
# Date::
#
module StringTool

  #
  # === 単語のリストから半角文字を除去する
  #
  def remove_zenkaku(word_array)
    new_word_array = Array.new ;
    word_array.each do |word|
      word.scan(/./) do |i|
        if(/[ -~｡-ﾟ]/ =~ i)
          break ;
        else
          new_word_array.push(word) ;
        end
      end
    end
    return new_word_array ;
  end

  module_function :remove_zenkaku;
  
  #
  # === テキストデータから単語を取り出す
  # @param text 対象テキスト
  # @return word_array array 結果の単語リスト
  #
  def get_words(text)
    mecab = MeCab::Tagger.new
    node = mecab.parseToNode(text)
    word_array = []
     #名詞だけとってくる
      begin
         return word_array if node.next == nil

        node = node.next
        if /^名詞/ =~ node.feature.force_encoding("UTF-8")
          word_array << node.surface.force_encoding("UTF-8")
        end
      end until node.next.feature.include?("BOS/EOS")

      return word_array ;
  end

  module_function :get_words;

end

