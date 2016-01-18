require_relative 'economic_profile_repository'

class EconomicProfile
  attr_reader :name,
              :median_household_income,
              :children_in_poverty,
              :free_or_reduced_price_lunch,
              :title_i,
              :data

  def initialize(data)
    @data = data
    @name = data[:name].upcase unless data[:name].nil?
    @median_household_income     = data[:median_household_income]
    @children_in_poverty         = data[:children_in_poverty]
    @free_or_reduced_price_lunch = data[:free_or_reduced_price_lunch]
    @title_i                     = data[:title_i]
  end

  def median_household_income_in_year(year)

  end
end
