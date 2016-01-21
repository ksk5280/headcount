require_relative 'district_repository'
require 'pry'

class HeadcountAnalyst
  attr_reader :district_hash,
              :district_growth

  GRADES = [3, 8]

  def initialize(district_repo)
    @district_hash = district_repo.districts
  end

  def kindergarten_participation_rate_variation(d1_name, compared)
    rate_variation(d1_name, compared, :kindergarten)
  end

  def graduation_rate_variation(d1_name, compared)
    rate_variation(d1_name, compared, :high_school_graduation)
  end

  def rate_variation(d1_name, compared, type)
    d1_avg = find_average(d1_name, type)
    d2_name = compared.fetch(:against)
    d2_avg = find_average(d2_name, type)
    d1_avg / d2_avg
  end

  def find_average(district_name, school_age)
    participation = district_hash.fetch(district_name).fetch(school_age)
    district_sum = participation.values.reduce(0, :+)
    district_sum / participation.keys.count
  end

  def kindergarten_participation_rate_variation_trend(d1_name, compared)
    d1_participation = district_hash.fetch(d1_name).fetch(:kindergarten)
    d2_name = compared.fetch(:against)
    d2_participation = district_hash.fetch(d2_name).fetch(:kindergarten)
    d1_participation.merge(d2_participation) { |year, d1, d2| ( d1 / d2 ).round(3) }
    district_participation =
      district_hash.fetch(district_name).fetch(school_age)
    district_sum = district_participation.values.reduce(0, :+)
    district_average = district_sum / district_participation.keys.count
  end

  def kindergarten_participation_rate_variation_trend(district1_name, compared)
    d1_participation = district_hash.fetch(district1_name).fetch(:kindergarten)

    district2_name = compared.fetch(:against)
    d2_participation = district_hash.fetch(district2_name).fetch(:kindergarten)

    d1_participation.merge(d2_participation) do |year, d1, d2|
      ( d1 / d2 ).round(3)
    end
  end

  def kindergarten_participation_against_high_school_graduation(district_name)
    return 0 if district_hash.fetch(district_name).fetch(:kindergarten).empty? || district_hash.fetch(district_name).fetch(:high_school_graduation).empty?
    kg_variation = kindergarten_participation_rate_variation(district_name, :against => "COLORADO")
    grad_variation = graduation_rate_variation(district_name, :against => "COLORADO")
    kg_variation / grad_variation

    kindergarten_variation =
      kindergarten_participation_rate_variation(district_name,
      :against => "COLORADO")
    graduation_variation = graduation_rate_variation(district_name,
      :against => "COLORADO")
    kindergarten_variation / graduation_variation
  end

  def kindergarten_participation_correlates_with_high_school_graduation(correlation)
    if correlation.key?(:for)
      name = correlation.fetch(:for)
      if name == 'STATEWIDE'
        correlation_for_statewide
      else
        correlation_for_one_district(name)
      end
    else
      district_array = correlation.fetch(:across)
      correlation_across_districts(district_array)
    end
  end

  def correlation_for_one_district(district_name)
    return true if kindergarten_participation_against_high_school_graduation(district_name).between?(0.6, 1.5)
  end

  def correlation_for_statewide
    correlated = district_hash.keys.select do |district|
      kindergarten_participation_correlates_with_high_school_graduation(:for => district) unless district == 'COLORADO'
    end
    return true if correlated.count / (district_hash.keys.count - 1) > 0.7
  end

  def correlation_across_districts(district_array)
    correlations = district_array.select do |district|
      kindergarten_participation_against_high_school_graduation(district).between?(0.6, 1.5)
    end
    return true if correlations.count /
    (district_array.count) > 0.7
  end

  def error_check(grade)
    raise InsufficientInformationError,
      "A grade must be provided to answer this question" if grade.nil?
    raise UnknownDataError,
      "#{grade} is not a known grade" unless GRADES.include?(grade)
  end

  def district_yoy_growth(district, grade, subject)
    grade_hash = clean_district_hash(district, grade, subject)
    return nil if grade_hash.empty?
    years = grade_hash.keys.sort
    if years.count >= 2
      last_year_data = grade_hash.fetch(years.last).fetch(subject)
      first_year_data = grade_hash.fetch(years.first).fetch(subject)
      avg_percent_growth =
        (last_year_data - first_year_data) / (years.last - years.first)
    end
    avg_percent_growth
  end

  def top_statewide_test_year_over_year_growth(data)
    grade = data[:grade]
    error_check(grade)
    grade = symbolize_grade(grade)
    subject = data[:subject]
    weighting = data[:weighting]
    @district_growth = []
    avg_yoy_growth_across_subjects(subject, grade, weighting)
    top_check(data)
  end

  def avg_yoy_growth_across_subjects(subject, grade, weighting)
    district_hash.each_key do |district|
      if subject == nil
        subjects = [:math, :reading, :writing]
        valid = subjects.select do |subject|
          district_yoy_growth(district, grade, subject)
        end
        num = valid.count
        next if num <= 1
        subject_sum = valid.reduce(0) do |sum, subject|
          unless weighting.nil?
            unweighted = district_yoy_growth(district, grade, subject)
            sum + (weighting[subject] * unweighted)
          else
            sum + district_yoy_growth(district, grade, subject)
          end
        end
        if weighting.nil?
          avg_across_subjects = subject_sum / num
        else
          avg_across_subjects = subject_sum
        end
        district_growth << [district, avg_across_subjects]
      else
        avg_percent_growth = district_yoy_growth(district, grade, subject)
        next if avg_percent_growth.nil?
        district_growth << [ district, avg_percent_growth ]
      end
    end
  end

  def top_check(data)
    if data[:top]
      num = data[:top]
      sorted = district_growth.sort_by {|growth_arr| growth_arr[1] }
      sorted[-num..-1]
    else
      district_growth.max_by {|growth_arr| growth_arr[1] }
    end
  end

  def symbolize_grade(grade)
    { 3 => :third_grade, 8 => :eighth_grade }[grade]
  end

  def clean_district_hash(district, grade, subject)
    district_grade_data = district_hash.fetch(district).fetch(grade).dup
    d = district_grade_data.keep_if { |_k, v| v.keys.include?(subject) }
  end
end
