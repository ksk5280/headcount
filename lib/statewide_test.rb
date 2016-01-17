require_relative 'statewide_test_repository'

class StatewideTest
  attr_reader :name,
              :third_grade,
              :eighth_grade,
              :math,
              :reading,
              :writing,
              :data

  def initialize(data)
    @data         = data
    @name         = data[:name].upcase
    @third_grade  = data[:third_grade]
    @eighth_grade = data[:eighth_grade]
    @math         = data[:math]
    @reading      = data[:reading]
    @writing      = data[:writing]
  end

  def proficient_by_grade(grade)
    if grade == 3
      return third_grade
    elsif
      eighth_grade
    else
      raise UnknownDataError
      # third_grade.each do |k, v|
    end
  end

  def proficient_by_race_or_ethnicity(race)
    subjects = {:math => math, :reading => reading, :writing => writing}
    race_hash = {}
    subjects.each do |k, v|
      v.keys.each do |year|
        if !race_hash.has_key?(year)
          race_hash[year] = {}
        end
        race_hash.fetch(year)[k] = v.fetch(year).fetch(race)
      end
    end
    race_hash
  end

end
