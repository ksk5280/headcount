require 'headcount_analyst'
require 'test_helper'

class HeadcountAnalystTest < Minitest::Test
  def test_it_initializes_with_a_district_repository
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kindergarten_edge_cases.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)

    assert_equal DistrictRepository, ha.district_repos.class
  end

  def test_enrollment_analysis_basics
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)

    actual = ha.kindergarten_participation_rate_variation("GUNNISON WATERSHED RE1J", :against => "TELLURIDE R-1")
    assert_in_delta 1.126, actual, 0.005

    actual = ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'YUMA SCHOOL DISTRICT 1')
    assert_in_delta 0.447, actual, 0.005

    actual = ha.kindergarten_participation_rate_variation('AGATE 300', :against => 'COLORADO')
    assert_in_delta 1.885, actual, 0.005
  end
end
