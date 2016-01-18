require_relative 'data_loader'
require_relative 'statewide_test'

class StatewideTestRepository
  attr_reader :statewide_tests

  def load_data(data)
    @statewide_tests = DataLoader.new.load_statewide_tests_csv(data)
  end

  def find_by_name(name)
    name = name.upcase
    if statewide_tests.has_key?(name)
      StatewideTest.new({
        :name => name,
        :third_grade => statewide_tests.fetch(name).fetch(:third_grade),
        :eighth_grade => statewide_tests.fetch(name).fetch(:eighth_grade),
        :math => statewide_tests.fetch(name).fetch(:math),
        :reading => statewide_tests.fetch(name).fetch(:reading),
        :writing => statewide_tests.fetch(name).fetch(:writing)
      })
    end
  end
end

if __FILE__ == $0
  str = StatewideTestRepository.new
  str.load_data(
    {
      :statewide_testing =>
        {
          :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
          :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
          :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
          :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
          :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
        }
    })
  puts @statewide_tests
end
