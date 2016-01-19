require_relative 'district_repository'
require 'pry'

class HeadcountAnalyst
  attr_reader :district_hash

  GRADES = [3, 8]

  def initialize(district_repo)
    @district_hash = district_repo.districts
    # district_repo is an instance of DistrictRepository
    # district_hash is a hash of all districts and their school_age and their participation values { year => percentage }
  end

  def kindergarten_participation_rate_variation(district1_name, compared)
    district1_average = find_average(district1_name, :kindergarten)
    district2_name = compared.fetch(:against)
    district2_average = find_average(district2_name, :kindergarten)

    ratio = district1_average / district2_average
  end

  def graduation_rate_variation(district1_name, compared)
    district1_average = find_average(district1_name, :high_school_graduation)
    district2_name = compared.fetch(:against)
    district2_average = find_average(district2_name, :high_school_graduation)
    ratio = district1_average / district2_average
  end

  # district_average = for any district the sum the percentages and divide by the total number of percentages
  def find_average(district_name, school_age)
    district_participation = district_hash.fetch(district_name).fetch(school_age)
    district_sum = district_participation.values.reduce(0, :+)
    district_average = district_sum / district_participation.keys.count
  end

  def kindergarten_participation_rate_variation_trend(district1_name, compared)
    #find district repo values by year and compare them.
    d1_participation = district_hash.fetch(district1_name).fetch(:kindergarten)

    district2_name = compared.fetch(:against)
    d2_participation = district_hash.fetch(district2_name).fetch(:kindergarten)

    d1_participation.merge(d2_participation) { |year, d1, d2| ( d1 / d2 ).round(3) }

    #return years with value of ratio between district1 and compared
  end

  def kindergarten_participation_against_high_school_graduation(district_name)
    # note: "EAST YUMA COUNTY RJ-2" and "WEST YUMA COUNTY RJ-1" have no data for kindergarten participation"
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
      #yields and array of correlations for all districts provided
    end
    return true if correlations.count/
    (district_array.count) > 0.7
  end

  def top_statewide_test_year_over_year_growth(grade, subject)
    raise UnknownDataError, "#{grade} is not a known grade" unless GRADES.include?(grade)
    raise InsufficientInformationError, "A grade must be provided to answer this question" if grade.nil?
    #for each district do
    #years = district_hash.fetch(district_name).fetch(grade).keys. sort
    #district_hash.fetch(district_name).fetch(grade).fetch(years.last).fetch(subject) - district_hash.fetch(district_name).fetch(grade).fetch(years.first).fetch(subject)
    #divided by
    #(years.last - years.first)
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
