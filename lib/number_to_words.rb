# https://stackoverflow.com/a/43522719 + couple of fixes

NUMBERS_TO_NAME = {
  10_000_000 => "crore",
  100_000 => "lakh",
  1000 => "thousand",
  100 => "hundred",
  90 => "ninety",
  80 => "eighty",
  70 => "seventy",
  60 => "sixty",
  50 => "fifty",
  40 => "forty",
  30 => "thirty",
  20 => "twenty",
  19 => "nineteen",
  18 => "eighteen",
  17 => "seventeen",
  16 => "sixteen",
  15 => "fifteen",
  14 => "fourteen",
  13 => "thirteen",
  12 => "twelve",
  11 => "eleven",
  10 => "ten",
  9 => "nine",
  8 => "eight",
  7 => "seven",
  6 => "six",
  5 => "five",
  4 => "four",
  3 => "three",
  2 => "two",
  1 => "one"
}.freeze

LOG_FLOORS_TO_TEN_POWERS = {
  0 => 1,
  1 => 10,
  2 => 100,
  3 => 1000,
  4 => 1000,
  5 => 100_000,
  6 => 100_000,
  7 => 10_000_000
}.freeze

def number_to_words(num)
  num = num.to_i
  return '' if (num <= 0) || (num >= 100_000_000)

  log_floor = Math.log(num, 10).round(15).floor
  ten_power = LOG_FLOORS_TO_TEN_POWERS[log_floor]

  if num <= 20
    NUMBERS_TO_NAME[num]
  elsif log_floor == 1
    rem = num % 10
    [NUMBERS_TO_NAME[num - rem], number_to_words(rem)].join(' ')
  else
    [number_to_words(num / ten_power), NUMBERS_TO_NAME[ten_power], number_to_words(num % ten_power)].join(' ').strip
  end
end
