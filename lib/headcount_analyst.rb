require_relative 'district_repository'
require 'pry'

class HeadcountAnalyst
  attr_reader :district_hash,
              :district_growth

  GRADES = [3, 8]

  def initialize(district_repo)
    @district_hash = district_repo.districts
    # district_repo is an instance of DistrictRepository
    # district_hash is a hash of all districts and their school_age and their participation values { year => percentage }
  end

  def kindergarten_participation_rate_variation(district1_name, compared)
    rate_variation(district1_name, compared, :kindergarten)
  end

  def graduation_rate_variation(district1_name, compared)
    rate_variation(district1_name, compared, :high_school_graduation)
  end

  def rate_variation(district1_name, compared, type)
    district1_average = find_average(district1_name, type)
    district2_name = compared.fetch(:against)
    district2_average = find_average(district2_name, type)
    district1_average / district2_average
  end

  # district_average = for any district the sum of the percentages and divide by the total number of percentages
  def find_average(district_name, school_age)
    district_participation = district_hash.fetch(district_name).fetch(school_age)
    district_sum = district_participation.values.reduce(0, :+)
    district_average = district_sum / district_participation.keys.count
  end

  def kindergarten_participation_rate_variation_trend(district1_name, compared)
    d1_participation = district_hash.fetch(district1_name).fetch(:kindergarten)

    district2_name = compared.fetch(:against)
    d2_participation = district_hash.fetch(district2_name).fetch(:kindergarten)

    d1_participation.merge(d2_participation) { |year, d1, d2| ( d1 / d2 ).round(3) }

    #returns years with value of ratio between district1 and compared
  end

  def kindergarten_participation_against_high_school_graduation(district_name)
    return 0 if district_hash.fetch(district_name).fetch(:kindergarten).empty? || district_hash.fetch(district_name).fetch(:high_school_graduation).empty?

    kindergarten_variation = kindergarten_participation_rate_variation(district_name, :against => "COLORADO")
    graduation_variation = graduation_rate_variation(district_name, :against => "COLORADO")
    kindergarten_variation / graduation_variation
  end

  def kindergarten_participation_correlates_with_high_school_graduation(district_correlation)
    if district_correlation.key?(:for)
      district_name = district_correlation.fetch(:for)
      if district_name == 'STATEWIDE'
        correlation_for_statewide
      else
        correlation_for_one_district(district_name)
      end
    else
      district_array = district_correlation.fetch(:across)
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
      #yields an array of correlations for all districts provided
    end
    return true if correlations.count/
    (district_array.count) > 0.7
  end

  def error_check(grade)
    raise InsufficientInformationError, "A grade must be provided to answer this question" if grade.nil?
    raise UnknownDataError, "#{grade} is not a known grade" unless GRADES.include?(grade)
  end
  
  def district_yoy_growth(district, grade, subject)
    grade_hash = clean_district_hash(district, grade, subject)
    return nil if grade_hash.empty?
    years = grade_hash.keys.sort
    if years.count >= 2
      last_year_data = grade_hash.fetch(years.last).fetch(subject)
      first_year_data = grade_hash.fetch(years.first).fetch(subject)
      avg_percent_growth = (last_year_data - first_year_data) / (years.last - years.first)
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

if __FILE__ == $0
  dr = DistrictRepository.new
  # file = "test/fixtures/kindergarten_edge_cases.csv"
  # file = "data/Kindergartners in full-day program.csv"
  # dr.load_data({
  #   :enrollment => {
  #     :kindergarten => file
  #   }
  # })
  # # dr.load_data({
  # #   :enrollment => {
  # #     :kindergarten => "./test/fixtures/small_kg_fixture.csv",
  # #     :high_school_graduation => "./test/fixtures/small_hs_fixture.csv"}})
  # ha = HeadcountAnalyst.new(dr)
  # ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')
  dr = DistrictRepository.new
  dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv",
                                :high_school_graduation => "./data/High school graduation rates.csv"}})
  ha = HeadcountAnalyst.new(dr)
  districts = ["ACADEMY 20", 'PARK (ESTES PARK) R-3', 'YUMA SCHOOL DISTRICT 1']
   ha.kindergarten_participation_correlates_with_high_school_graduation(:across => districts)
end
