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

frames = shots.each_slice(2).to_a

# 先に10フレーム目を整理する
# 10フレーム目は投数に関わらずframes[9]にすべて収め、合計するだけで点数を出せるようにする
if frames.length == 12 # 3投目が存在する場合（10フレーム目の1投目と2投目が10の場合）
  frames[-3].concat(frames[-2]).concat(frames[-1]) # 最後と最後から２番目の配列を、最後から3番目の配列に合体する
  2.times { frames.delete_at(-1) }  # 合体済みの配列を削除する
  frames[9].delete_at(1)  # 10フレーム目（最後の配列）の2番目の0は不要なので削除する
elsif frames.length == 11 # 3投目が存在する場合
  frames[-2].concat(frames[-1]) # 最後の配列を最後から2番目の配列に合体する
  frames.delete_at(-1) # 合体済みの配列を削除する
  if frames[9][0] == 10 # 10フレーム目の2番目の数字が0の場合
    frames[9].delete_at(1) # 不要な0を削除する
  end
end

def strike(frame, i, frames)
  if i <= 7 && frames[i + 1][0] == 10
    frame.sum + 10 + frames[i + 2][0]
  elsif i <= 8
    frame.sum + frames[i + 1][0] + frames[i + 1][1]
  else  # 10フレーム目
    frame.sum
  end
end

def spare(frame, i, frames)
  if i <= 8
    frame.sum + frames[i + 1][0]
  else
    frame.sum  # 10フレーム目
  end
end

point = frames.each_with_index.sum do |frame, i|
          if frame[0] == 10  # strikeの場合
            strike(frame, i, frames)
          elsif frame.sum == 10  # spareの場合
            spare(frame, i, frames)
          else  # その他の場合
            frame.sum
          end
        end
  
puts point
