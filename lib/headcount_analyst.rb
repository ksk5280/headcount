require_relative 'district_repository'
require 'pry'
# require 'pry-byebug'

class HeadcountAnalyst
  attr_accessor :district_repos

  def initialize(district_repos)
    @district_repos = district_repos
    # district_repos is an instance of DistrictRepository
    # district_repos.districts is a hash of all districts and their school_age and their participation values { year => percentage }
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
    district_participation = district_repos.districts.fetch(district_name).fetch(school_age)
    district_sum = district_participation.values.reduce(0, :+)
    district_average = district_sum / district_participation.keys.count
  end

  def kindergarten_participation_rate_variation_trend(district1_name, compared)
    #find district repo values by year and compare them.
    d1_participation = district_repos.districts.fetch(district1_name).fetch(:kindergarten)

    district2_name = compared.fetch(:against)
    d2_participation = district_repos.districts.fetch(district2_name).fetch(:kindergarten)

    d1_participation.merge(d2_participation) { |year, d1, d2| ( d1 / d2 ).round(3) }

    #return years with value of ratio between district1 and compared
  end

  def kindergarten_participation_against_high_school_graduation(district_name)
    kindergarten_variation = kindergarten_participation_rate_variation(district_name, :against => "COLORADO")
    graduation_variation = graduation_rate_variation(district_name, :against => "COLORADO")
    kindergarten_variation / graduation_variation
  end

  def kindergarten_participation_correlates_with_high_school_graduation(district_correlation)
    # require "pry"
    # binding.pry
    district_name = district_correlation.fetch(:for)
    if district_name == 'STATEWIDE'
      correlated = district_repos.districts.keys.select do |district|
        kindergarten_participation_correlates_with_high_school_graduation(district)
        return false if district == 'COLORADO'
      end
      return true if correlated.count / district_repos.districts.keys.count > 0.7
    else
      return true if kindergarten_participation_against_high_school_graduation(district_name).between?(0.6, 1.5)
    end
  end
end


if __FILE__ == $0
  dr = DistrictRepository.new
  # file = "test/fixtures/kindergarten_edge_cases.csv"
  file = "data/Kindergartners in full-day program.csv"
  dr.load_data({
    :enrollment => {
      :kindergarten => file
    }
  })
  # dr.load_data({
  #   :enrollment => {
  #     :kindergarten => "./test/fixtures/small_kg_fixture.csv",
  #     :high_school_graduation => "./test/fixtures/small_hs_fixture.csv"}})
  ha = HeadcountAnalyst.new(dr)
  ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')
end
