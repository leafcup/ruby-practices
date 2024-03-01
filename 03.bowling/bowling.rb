#!/usr/bin/env ruby

score = ARGV[0]
scores = score.split(',')

shots = []
scores.each do |s|
  if s == 'X'
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end

frames = []
shots.each_slice(2) do |s|
  frames << s
end

# 先に10フレーム目を整理する
# 10フレーム目は投数に関わらずframes[9]にすべて収め、合計するだけで点数を出せるようにする
if frames[9][0] == 10 && frames[10][0] == 10 # 3投目が存在する場合（10フレーム目の1投目と2投目が10の場合）
  frames[-3].concat(frames[-2]).concat(frames[-1]) # 最後と最後から２番目の配列を、最後から3番目の配列に合体する
  2.times { frames.pop }  # 合体済みの配列を削除する
  frames[9].delete_at(1)  # 10フレーム目（最後の配列）の2番目の0は不要なので削除する
elsif frames[9][0] == 10 || frames[-1].length == 1 # 3投目が存在する場合
  frames[-2].concat(frames[-1]) # 最後の配列を最後から2番目の配列に合体する
  frames.pop # 合体済みの配列を削除する
  if frames[9][0] == 10 # 10フレーム目の2番目の数字が0の場合
    frames[9].delete_at(1) # 不要な0を削除する
  end
end

point = 0
frames.each_with_index do |frame, i|
  point += if frame[0] == 10 # strikeの場合
             if i <= 7 # 1〜8フレーム目
               if frames[i + 1][0] == 10
                 frame.sum + frames[i + 1][0] + frames[i + 2][0]
               else
                 frame.sum + frames[i + 1][0] + frames[i + 1][1]
               end
             elsif i == 8 # 9フレーム目
               frame.sum + frames[i + 1][0] + frames[i + 1][1]
             else # 10フレーム目
               + frame.sum
             end
           elsif frame.sum == 10 # spareの場合
             if i <= 8 # 1〜9フレーム目
               frame.sum + frames[i + 1][0]
             else # 10フレーム目
               + frame.sum
             end
           else # strikeでもspareでもない場合
             + frame.sum
           end
end

puts point
