require_relative 'statewide_test_repository'
require_relative 'custom_errors'

class StatewideTest
  attr_reader :data,
              :name,
              :third_grade,
              :eighth_grade,
              :math,
              :reading,
              :writing

  def initialize(data)
    @data         = data
    @name         = data[:name].upcase
    @third_grade  = data[:third_grade]
    @eighth_grade = data[:eighth_grade]
    @math         = data[:math]
    @reading      = data[:reading]
    @writing      = data[:writing]
  end

  RACES = [:all_students, :asian, :black, :hawaiian_pacific_islander, :hispanic, :native_american, :two_or_more, :white]
  SUBJECTS = [:math, :reading, :writing]

  def proficient_by_grade(grade)
    if grade == 3
      return third_grade
    elsif grade == 8
      eighth_grade
    else
      raise UnknownDataError, 'Unknown grade'
    end
  end

  def proficient_by_race_or_ethnicity(race)
    raise UnknownRaceError unless RACES.include?(race)
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

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    raise UnknownDataError unless SUBJECTS.include?(subject)
  end
end
