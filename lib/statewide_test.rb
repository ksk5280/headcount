require_relative 'statewide_test_repository'

class StatewideTest
  attr_reader :name,
              :third_grade,
              :eighth_grade,
              :math,
              :reading,
              :writing

  def initialize(data)
    @name         = data[:name].upcase
    @third_grade  = data[:third_grade]
    @eighth_grade = data[:eighth_grade]
    @math         = data[:math]
    @reading      = data[:reading]
    @writing      = data[:writing]
  end
end
