#!/usr/bin/env ruby

# frozen_string_literal: true

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

while frames.length > 10
  frames[-2].concat(frames[-1])
  frames.delete_at(-1) # 合体済みの配列を削除する
  frames[-1].delete_at(1) if frames[-1][0] == 10
end

def strike(fnum, next_frame, next_next_frame)
  if fnum <= 7 && next_frame[0] == 10
    10 + next_next_frame[0]
  elsif fnum <= 8
    next_frame[0..1].sum
  else # 10フレーム目
    0
  end
end

def spare(fnum, next_frame)
  if fnum <= 8
    next_frame[0]
  else # 10フレーム目
    0
  end
end

point = frames.each_with_index.sum do |frame, fnum|
  frame.sum + if frame[0] == 10 # strikeの場合
                strike(fnum, frames[fnum + 1], frames[fnum + 2])
              elsif frame.sum == 10 # spareの場合
                spare(fnum, frames[fnum + 1])
              else # その他の場合
                0
              end
end

puts point
