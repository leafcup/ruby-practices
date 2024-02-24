#!/usr/bin/env ruby

require "date"
require "optparse"

# プログラム実行時に指定したオプションの引数を受け取る
opt = OptionParser.new
opt.on("-y VAL") {|y| @year = y.to_i }  # calの場合、年の小数点は整数に丸められるのでここで数値に変換する
opt.on("-m VAL") {|m| @month = m }  # calの場合、月の小数点は整数に丸めないので、ここでは文字列のまま通す
opt.parse(ARGV)

# オプションが指定されなかった場合は年を今年、月を今月で処理する
# 年は1以上9999以下、月は1以上12以下が有効値。それ以外の数値、文字列が渡された時はエラーにする
# calと同じにするため、月は小数が渡された場合は整数に丸めずにエラーにする
if @year == nil
  @year = Date.today.year  # 年が未指定のときは本日扱い
elsif @year < 1 || @year > 9999 
  puts "year `#{@year}' not in range 1..9999"
  exit
else
end

if @month == nil
  @month = Date.today.month  # 月が未指定のときは本日扱い
elsif @month.to_i < 1 || @month.to_i > 12 || @month.include?(".")
  puts "#{@month} is neither a month number (1..12) nor a name"
  exit
else
  @month = @month.to_i  # すべて通過できたら変数を数値に変換する
end

# 要求されている年、月のデータを定義
date_start = Date.new(@year, @month, 1)
date_end = Date.new(@year, @month, -1)

# 要求されているカレンダーの年月日を中央寄せで出力する
puts "#{date_start.month}月 #{date_start.year}".center(20)

# 曜日を出力する
week = ["日", "月", "火", "水", "木", "金", "土"]
week.map do |w|
  if w == "土"
    puts "#{w} "  # 土曜の時は改行する
  else
    print "#{w} "  # 土曜以外は改行しない
  end
end

# 1日を曜日の位置に合わせる
print "   " * date_start.wday

# 指定の年、月の日付を出力
(date_start..date_end).each do |d|
  if d.wday == 6  # 土曜日の場合
    if d == Date.today  # 本日の場合、印をつけて出力。折り返す、右寄せ
      puts "\e[30m\e[42m#{d.day}\e[0m ".rjust(3)
    else
      puts "#{d.day} ".rjust(3)  # 折り返す、右寄せ
    end
  else  # 土曜日以外の場合
    if d == Date.today  # 本日の場合、印をつけて出力。折り返さない、右寄せ
      print "\e[30m\e[42m#{d.day}\e[0m ".rjust(3)
    else
      print "#{d.day} ".rjust(3)  # 折り返さない、右寄せ
    end
  end
end
