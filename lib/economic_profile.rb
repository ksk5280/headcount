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
    check_for_known_year(year)
    year_included = median_household_income.select do |year_range, currency|
      year.between?(year_range.first, year_range.last)
    end
    sum = year_included.values.reduce(:+)
    average = sum/year_included.count
  end

  def check_for_known_year(year)
    raise UnknownDataError, "Year is not included" unless year_in_range?(year)
  end

  def year_in_range?(year)
    median_household_income.keys.any? { |year_range| year.between?(year_range[0], year_range[1]) }
  end

  def median_household_income_average
    sum = median_household_income.values.reduce(:+)
    count = median_household_income.keys.count
    average = sum / count
  end

  def children_in_poverty_in_year(year)
    raise UnknownDataError unless children_in_poverty.keys.include?(year)
    children_in_poverty.fetch(year)
  end

  def free_or_reduced_price_lunch_percentage_in_year(year)
    raise UnknownDataError unless free_or_reduced_price_lunch.keys.include?(year)
    free_or_reduced_price_lunch.fetch(year)

  end
end
