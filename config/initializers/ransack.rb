# Overriding :wants_array because of an issue with ransack
# https://github.com/activerecord-hackery/ransack/issues/32

module Ransack
  class Predicate
    attr_accessor :wants_array
  end
end

Ransack.configure do |config|
  config.add_predicate 'daterange',
                       arel_predicate: 'in',
                       formatter: proc { |v| date_strings = v.split("-");
                         DateTime.parse(date_strings[0])..DateTime.parse(date_strings[1]).end_of_day },
                       validator: proc { |v| v.present? }
end

Ransack::predicates['daterange'].wants_array = false
