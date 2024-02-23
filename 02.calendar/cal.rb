#!/usr/bin/env ruby
require "date"
require "optparse"

# プログラム実行時に指定したオプションの引数を受け取る
opt = OptionParser.new
opt.on("-y VAL") {|y| @y = y.to_i }
opt.on("-m VAL") {|m| @m = m.to_i }  
opt.parse(ARGV)

# オプションが指定されなかった場合は今年、今月で処理する
if @y == nil
  @y = Date.today.year
else
end

if @m == nil
  @m = Date.today.month
else
end

# 要求されている年、月のデータを定義
date_start = Date.new(@y, @m, 1)
date_end = Date.new(@y, @m, -1)

# 曜日を出力
puts "#{date_start.month}月 #{date_start.year}".center(20)
week = ["日", "月", "火", "水", "木", "金", "土"]
week.map do |w|
  print "#{w} "  # 隙間の調整
end
  puts "\n"  # 最後に改行する

# 1日を曜日の位置に合わせる
print "   " * date_start.wday

# 指定の年、月の日付を出力
(date_start..date_end).each do |d|
  if d.wday == 6  # 土曜日の場合
    puts "#{d.day} ".rjust(3)  # 折り返す（空白を取りつつ、1の位を揃えるために右寄せ）
  else  # 土曜日以外の場合
    print "#{d.day} ".rjust(3)  # 折り返さない（空白を取りつつ、1位を揃えるために右寄せ）
  end
end
