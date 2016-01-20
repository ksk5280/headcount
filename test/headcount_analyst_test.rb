require 'headcount_analyst'
require 'test_helper'

class HeadcountAnalystTest < Minitest::Test
  def test_class_exists
    assert HeadcountAnalyst
  end

  def test_headcount_analyst_is_initialized_with_a_district_repository
    dr = DistrictRepository.new
    dr.load_data({
      :economic_profile => {
        :median_household_income => "test/fixtures/median_income_fixture.csv",
        :children_in_poverty => "test/fixtures/poverty_fixture.csv",
        :free_or_reduced_price_lunch => "test/fixtures/free_lunch_fixture.csv",
        :title_i => "test/fixtures/title_i_fixture.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)
    assert_equal Hash, ha.district_hash.class
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

  def test_can_assert_that_state_has_a_correlation_between_kg_participation_and_hs_graduation
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

  def test_can_detect_wrong_correlation_across_a_subset_of_districts
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv",
                                  :high_school_graduation => "./data/High school graduation rates.csv"}})
    ha = HeadcountAnalyst.new(dr)
    districts = ["ACADEMY 20", 'BENNETT 29J', 'YUMA SCHOOL DISTRICT 1']
    refute ha.kindergarten_participation_correlates_with_high_school_graduation(:across => districts)
  end

  def test_can_find_correlation_across_a_subset_of_districts
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv",
                                  :high_school_graduation => "./data/High school graduation rates.csv"}})
    ha = HeadcountAnalyst.new(dr)
    districts = ["ACADEMY 20", 'BAYFIELD 10 JT-R', 'YUMA SCHOOL DISTRICT 1']
    assert ha.kindergarten_participation_correlates_with_high_school_graduation(:across => districts)
  end

  def test_that_empty_data_is_removed_from_district_hash
    dr = DistrictRepository.new
    dr.load_data({
      :statewide_testing =>
        {
        :third_grade => 'test/fixtures/grade_3_fixture.csv',
        :eighth_grade => 'test/fixtures/grade_8_fixture.csv'
      }
    })
    ha = HeadcountAnalyst.new(dr)
    actual = ha.clean_district_hash("AGATE 300", :third_grade, :writing)
    expected = {2008=>{:writing=>0.278}, 2009=>{:writing=>0.29}}
    assert_equal expected, actual
    actual = ha.clean_district_hash("AGATE 300", :third_grade, :math)
    expected = {}
    assert_equal expected, actual
  end

  def test_can_find_top_2_year_growth
    dr = district_repository_with_testing_data
    ha = HeadcountAnalyst.new(dr)
    actual = ha.top_statewide_test_year_over_year_growth(grade: 3, top: 2, subject: :math)
    expected = [["ACADEMY 20", -0.00366666666666667], ["COLORADO", 0.0031666666666666696]]
    assert_equal expected, actual
  end

  def test_statewide_testing_relationships
    dr = district_repository_with_testing_data
    ha = HeadcountAnalyst.new(dr)

    assert_equal "COLORADO", ha.top_statewide_test_year_over_year_growth(grade: 3, subject: :math).first
    assert_in_delta 0.003, ha.top_statewide_test_year_over_year_growth(grade: 3, subject: :math).last, 0.005

    assert_equal "ACADEMY 20", ha.top_statewide_test_year_over_year_growth(grade: 8, subject: :reading).first
    assert_in_delta -0.0026, ha.top_statewide_test_year_over_year_growth(grade: 8, subject: :reading).last, 0.005

    assert_equal "AGATE 300", ha.top_statewide_test_year_over_year_growth(grade: 3, subject: :writing).first
    assert_in_delta 0.012, ha.top_statewide_test_year_over_year_growth(grade: 3, subject: :writing).last, 0.005
  end

  def test_district_growth_over_all_subjects
    dr = district_repository_with_testing_data
    ha = HeadcountAnalyst.new(dr)
    ha.district_yoy_growth('AGATE 300', :third_grade, :math)
  end

  def test_statewide_year_over_year_growth_overall
    dr = district_repository_with_testing_data
    ha = HeadcountAnalyst.new(dr)
    actual = ha.top_statewide_test_year_over_year_growth(grade: 3).last
    assert_in_delta 0.002, actual, 0.005
  end

meta t: true
  def test_weighted_average_growth
    dr = district_repository_with_testing_data
    ha = HeadcountAnalyst.new(dr)
    weighted_actual_arr = ha.top_statewide_test_year_over_year_growth(grade: 8, :weighting => {:math => 0.5, :reading => 0.5, :writing => 0.0})
    actual = weighted_actual_arr.first
    assert_equal 'ACADEMY 20', actual
    actual = weighted_actual_arr.last
    assert_in_delta 0.00241, actual, 0.005
  end

  def district_repository_with_testing_data
    dr = DistrictRepository.new
    dr.load_data({
      :statewide_testing =>
        {
        :third_grade => 'test/fixtures/grade_3_fixture.csv',
        :eighth_grade => 'test/fixtures/grade_8_fixture.csv'
      }
    })
    dr
  end
end
