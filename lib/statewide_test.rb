require_relative 'statewide_test_repository'
require_relative 'custom_errors'

class StatewideTest
  attr_reader :data,
              :name,
              :third_grade,
              :eighth_grade,
              :math,
              :reading,
              :writing,
              :subjects

  def initialize(data)
    @data         = data
    @name         = data[:name].upcase
    @third_grade  = data[:third_grade]
    @eighth_grade = data[:eighth_grade]
    @math         = data[:math]
    @reading      = data[:reading]
    @writing      = data[:writing]
    @subjects     = { :math => math,
                      :reading => reading,
                      :writing => writing }
  end

  RACES    = [ :all_students,
               :asian,
               :black,
               :hawaiian_pacific_islander,
               :hispanic,
               :native_american,
               :two_or_more,
               :white ]

  SUBJECTS = [ :math,
               :reading,
               :writing ]

  GRADE    = [ 3 , 8 ]

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
    race_hash = {}
    subjects.each do |k, v|
      v.keys.each do |year|
        if !race_hash.has_key?(year)
          race_hash[year] = {}
        end
        raise UnknownDataError if v.fetch(year).empty?
        race_hash.fetch(year)[k] = v.fetch(year).fetch(race)
      end
    end
    race_hash
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    grade_error_check(subject, grade, year)
    grades = proficient_by_grade(grade)
    if grades.fetch(year).empty?
      'N/A'
    else
      grades.fetch(year).fetch(subject)
    end
  end

  def proficient_for_subject_by_race_in_year(subject, race, year)
    race_error_check(subject, race, year)
    races = proficient_by_race_or_ethnicity(race)
    if races.fetch(year).empty?
      'N/A'
    else
      races.fetch(year).fetch(subject)
    end
  end

  def grade_error_check(subject, grade, year)
    raise UnknownDataError unless SUBJECTS.include?(subject) &&
      GRADE.include?(grade) && years(subject).include?(year)
  end

  def race_error_check(subject, race, year)
    raise UnknownDataError unless SUBJECTS.include?(subject) &&
      RACES.include?(race) && years(subject).include?(year)
  end
  
  def years(subject)
    subjects.fetch(subject).keys
  end
end
