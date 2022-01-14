#!/usr/bin/env ruby
require 'set'

# Usage: ./create_wordle_wordlist.rb words_alpha.txt > words_wordle.txt
#
# Creates a wordlist to be used for solving Wordle.
# The wordlist will contain only 5-letter words, and it will be sorted
# so that words containing the most frequent letters in the English language
# appear first.

lines = ARGF.readlines

words = lines.map(&:strip).select { |l| l.length == 5 }

# https://en.wikipedia.org/wiki/Letter_frequency
LETTER_FREQ = {
  a: 7.8,
  b: 2,
  c: 4,
  d: 3.8,
  e: 11,
  f: 1.4,
  g: 3,
  h: 2.3,
  i: 8.2,
  j: 0.21,
  k: 2.5,
  l: 5.3,
  m: 2.7,
  n: 7.2,
  o: 6.1,
  p: 2.8,
  q: 0.24,
  r: 7.3,
  s: 8.7,
  t: 6.7,
  u: 3.3,
  v: 1,
  w: 0.91,
  x: 0.27,
  y: 1.6,
  z: 0.44
}.freeze

EXCLUDE = Set.new(['contd'])

freq_scores = words.map do |w|
  score = w.chars.map { |c| LETTER_FREQ[c.to_sym] }.sum
  [w, score]
end

sorted = freq_scores.sort_by { |w, s| s }.reverse

sorted.select { |w, _|
  !EXCLUDE.include?(w)
}.each do |w, s|
  puts w
end
