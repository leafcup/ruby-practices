#!/usr/bin/env ruby

require "date"
require "optparse"

# プログラム実行時に指定したオプションの引数を受け取る
opt = OptionParser.new
opt.on("-y VAL") {|y| @year = y }
opt.on("-m VAL") {|m| @month = m }
opt.parse(ARGV)

# オプションが指定されなかった場合は年を今年、月を今月で処理する
# 年は1以上9999以下、月は1以上12以下が有効値。それ以外の数値、文字列が渡された時はエラーにする
# calと同じにするため、月は小数が渡された場合は整数に丸めずにエラーにする
@year = @year&.to_i || Date.today.year 
abort "年は1〜9999で指定してください" if @year < 1 || @year > 9999

if @month
  abort "月は整数で指定してください" unless @month.match?(/\A\d+\z/)
  @month = @month.to_i
  abort "月は1〜12で指定してください" if @month < 1 || @month > 12
else
  @month = Date.today.month
end

# 要求されている年、月のデータを定義
date_start = Date.new(@year, @month, 1)
date_end = Date.new(@year, @month, -1)

# 要求されているカレンダーの年月日を中央寄せで出力する
puts "#{date_start.month}月 #{date_start.year}".center(20)

# 曜日を出力する
week = ["日", "月", "火", "水", "木", "金", "土"]
puts week.join(" ")

# 1日を曜日の位置に合わせる
print "   " * date_start.wday

# 指定の年、月の日付を出力
(date_start..date_end).each do |d|
  date_string = "#{d.day}".rjust(2)
  date_string = "\e[7m#{date_string}\e[0m" if d == Date.today
  print "#{date_string} "
  puts if d.saturday? || d == date_end
end
