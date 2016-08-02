# -*- coding: utf-8 -*-

$LOAD_PATH.push(File::dirname($0)) ;
require "pry"
require "yaml"
require "csv"
require "narray"
require 'google-search'
require 'anemone'

# require "marshal"

#
# == 自分のクローラー用のライブラリ
#
# Author::Takuya Okano
# Version::
# Date::
#
module CrawlwerTool

  #
  # === 指定した文字をgoogleで検索してその
  # 検索結果のl結果
  #
  # @param search_word string 検索したいワード
  # @param size int 返したいリンクのサイズ
  #
  def google_search(search_word, size)
    urls = []
    #検索して出てきたurlを保存
    Google::Search::Web.new(:query => search_word).each do |item|
      # puts item.uri
      # puts item.title
      urls.push(item) 
      if count > size
        break
      end  
      count += 1 
    end
    return urls
  end

  module_function :google_search;

