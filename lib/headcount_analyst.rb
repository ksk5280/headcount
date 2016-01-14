require_relative 'district_repository'
require 'pry'

class HeadcountAnalyst
  attr_reader :district_repos

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

  def find_average(district_name)
    #district_repos.districts is a hash of all districts and their participation values { year => percentage }
    district_participation = district_repos.districts.fetch(district_name)
    district_sum = district_participation.values.reduce(0, :+)
    district_average = district_sum / district_participation.keys.count
  end
    # district_average = for any district the sum the percentages and divide by the total number of percentages
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
  ha = HeadcountAnalyst.new(dr)
  # puts dr.districts
  # puts dr.districts.fetch("COLORADO")
  # puts dr.districts.fetch("COLORADO").fetch(2010)
  # puts dr.districts
  puts ha.kindergarten_participation_rate_variation("AGATE 300", :against => "COLORADO")
end
