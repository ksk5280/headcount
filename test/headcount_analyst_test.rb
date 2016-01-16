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

  def test_calculates_ratio_of_average_kg_participation_between_districts
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

  def test_calculates_ratio_of_kg_participation_between_districts_by_year
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kindergarten_colo_v_ac20.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)

    actual = ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')
    expected = { 2009 => 0.652, 2010 => 0.681, 2011 => 0.728 }
    assert_equal expected, actual
  end

  def test_can_find_relationship_between_kg_participation_and_hs_graduation
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "test/fixtures/small_kg_fixture.csv",
        :high_school_graduation => "test/fixtures/small_hs_fixture.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)
    assert_in_delta 0.911, ha.kindergarten_participation_against_high_school_graduation('ADAMS COUNTY 14'), 0.005
    assert_in_delta 0.803, ha.kindergarten_participation_against_high_school_graduation('ACADEMY 20'), 0.005
  end

  def test_can_assert_that_there_is_a_correlation_between_kg_participation_and_hs_graduation
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "test/fixtures/small_kg_fixture.csv",
        :high_school_graduation => "test/fixtures/small_hs_fixture.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)
    assert ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'ACADEMY 20')
  end

  meta tag: true
  def test_can_assert_that_state_has_a_correlation_between_kg_participation_and_hs_graduation
    skip
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "test/fixtures/kg_statewide_fixture.csv",
        :high_school_graduation => "test/fixtures/hs_statewide_fixture.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)
    assert ha.kindergarten_participation_correlates_with_high_school_graduation(:for => 'STATEWIDE')
  end
end
