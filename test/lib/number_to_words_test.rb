require 'test_helper'

class NumberToWordsTest < ActiveSupport::TestCase
  test '.amount_in_words' do
    assert_equal 'one', number_to_words(1)
    assert_equal 'nine', number_to_words(9)
    assert_equal 'eleven', number_to_words(11)
    assert_equal 'nineteen', number_to_words(19)
    assert_equal 'ninety nine', number_to_words(99)
    assert_equal 'one hundred', number_to_words(100)
    assert_equal 'one hundred eleven', number_to_words(111)
    assert_equal 'nine hundred ninety nine', number_to_words(999)
    assert_equal 'one thousand', number_to_words(1000)
    assert_equal 'one thousand one', number_to_words(1001)
    assert_equal 'one thousand one hundred eleven', number_to_words(1111)
    assert_equal 'eleven thousand one', number_to_words(11001)
    assert_equal 'ninety nine thousand nine hundred ninety nine', number_to_words(99999)
    assert_equal 'one lakh', number_to_words(100_000)
    assert_equal 'eleven lakh ninety nine thousand', number_to_words(1_199_000)
    assert_equal 'ninety nine lakh ninety nine thousand nine hundred ninety nine', number_to_words(9_999_999)
    assert_equal 'one crore one lakh one thousand one', number_to_words(10_101_001)
    assert_equal 'nine crore ninety nine lakh ninety nine thousand nine hundred ninety nine', number_to_words(99_999_999)
  end
end
