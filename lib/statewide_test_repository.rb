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
