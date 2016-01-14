require_relative 'district_repository'
require 'pry'
# require 'pry-byebug'

class HeadcountAnalyst
  attr_accessor :district_repos

  def initialize(district_repos)
    @district_repos = district_repos
    # district_repos is an instance of DistrictRepository
  end

  def kindergarten_participation_rate_variation(district1_name, compared)
    district1_average = find_average(district1_name)
    district2_name = compared.fetch(:against)
    district2_average = find_average(district2_name)

    ratio = district1_average / district2_average
  end

  def graduation_rate_variation(district1_name, compared)
    district1_average = find_average(district1_name)
    district2_name = compared.fetch(:against)
    district2_average = find_average(district2_name)

    ratio = district1_average / district2_average
  end

  def find_average(district_name)
    #district_repos.districts is a hash of all districts and their participation values { year => percentage }
    district_participation = district_repos.districts.fetch(district_name).fetch(:kindergarten)
    district_sum = district_participation.values.reduce(0, :+)
    district_average = district_sum / district_participation.keys.count
  end
    # district_average = for any district the sum the percentages and divide by the total number of percentages

  def kindergarten_participation_rate_variation_trend(district1_name, compared)
    #find district repo values by year and compare them.
    d1_participation = district_repos.districts.fetch(district1_name).fetch(:kindergarten)

    district2_name = compared.fetch(:against)
    d2_participation = district_repos.districts.fetch(district2_name).fetch(:kindergarten)
    # binding.pry

    d1_participation.merge(d2_participation) { |year, d1, d2| ( d1 / d2 ).round(3) }

    #return years with value of ratio between district1 and compared
  end

  def kindergarten_participation_against_high_school_graduation(district_name)
    # district kindergarten average participation
    # district divided by high_school_graduation average

    # Colorado kindergarten average participation
    # Colorado divided by high_school_graduation average

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
