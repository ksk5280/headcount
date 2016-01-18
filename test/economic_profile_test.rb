require 'economic_profile'
require 'economic_profile_repository'
require 'test_helper'

class EconomicProfileTest < Minitest::Test
  def economic_profile_from_data
    epr = EconomicProfileRepository.new
    epr.load_data({
      :economic_profile => {
        :median_household_income => "test/fixtures/median_income_fixture.csv",
        :children_in_poverty => "test/fixtures/poverty_fixture.csv",
        :free_or_reduced_price_lunch => "test/fixtures/free_lunch_fixture.csv",
        :title_i => "test/fixtures/title_i_fixture.csv"
      }
    })
    epr.find_by_name('ACADEMY 20')
  end

meta t: true
  def test_economic_profile_works_with_loaded_data
    ep = economic_profile_from_data
    assert_equal 88279, ep.median_household_income_in_year(2010)
    assert_equal 87635, ep.median_household_income_average
    assert_equal 0.059, ep.children_in_poverty_in_year(2011)
    assert_equal 0.127, ep.free_or_reduced_price_lunch_percentage_in_year(2014)
    assert_equal 0.011, ep.title_i_in_year(2011)
  end

  def test_class_exists
    assert EconomicProfile
  end

  def test_it_has_a_name
    ep = EconomicProfile.new({
      :name => "ACADEMY 20",
    })
    assert_equal "ACADEMY 20", ep.name
  end

  def test_name_is_case_insensitive
    ep = EconomicProfile.new({
      :name => "academy 20",
    })
    assert_equal "ACADEMY 20", ep.name
  end

  def test_it_can_find_median_household_income_by_year
    ep = EconomicProfile.new({
      :name => "ACADEMY 20",
      :median_household_income => {[2012, 2013]=>50000, [2011, 2012]=>60000}
    })
    actual = ep.median_household_income_in_year(2012)
    assert_equal 55000, actual
    actual = ep.median_household_income_in_year(2013)
    assert_equal 50000, actual
  end

  def test_if_year_is_not_found_raise_unknown_data_error_for_med_income
    ep = EconomicProfile.new({
      :name => "ACADEMY 20",
      :median_household_income => {[2014, 2015]=>50000, [2013, 2014]=>60000}
    })
    assert_raises(UnknownDataError) do
      ep.median_household_income_in_year(2000)
    end
  end

  def test_if_year_is_not_found_raise_unknown_data_error_for_children_in_poverty
    ep = EconomicProfile.new({
      :name => "ACADEMY 20",
      :children_in_poverty => { 2012 => 0.1845 }
    })
    assert_raises(UnknownDataError) do
      ep.children_in_poverty_in_year(2000)
    end
  end

  def test_can_find_data_for_children_in_poverty_by_year
    ep = EconomicProfile.new({
      :name => "ACADEMY 20",
      :children_in_poverty => { 2012 => 0.1845 }
    })
    assert_in_delta 0.184, ep.children_in_poverty_in_year(2012), 0.005
  end

  def test_if_year_is_not_found_raise_unknown_data_error_for_free_lunch_percentage
    ep = EconomicProfile.new({
      :name => "ACADEMY 20",
      :free_or_reduced_price_lunch => { 2014 =>
        { :percentage => 0.023,
          :total      => 100 }
      }
    })
    assert_raises(UnknownDataError) do
      ep.free_or_reduced_price_lunch_percentage_in_year(1776)
    end
  end

  def test_can_find_percentage_for_free_lunch
    ep = EconomicProfile.new({
      :name => "ACADEMY 20",
      :free_or_reduced_price_lunch => { 2014 =>
        { :percentage => 0.023,
          :total      => 100 }
      }
    })
    assert_in_delta 0.023, ep.free_or_reduced_price_lunch_percentage_in_year(2014), 0.005
  end

meta t: true
  def test_if_year_is_not_found_raise_unknown_data_error_for_free_lunch_number
    ep = EconomicProfile.new({
      :name => "ACADEMY 20",
      :free_or_reduced_price_lunch => { 2014 =>
        { :percentage => 0.023,
          :total      => 100 }
      }
    })
    assert_raises(UnknownDataError) do
      ep.free_or_reduced_price_lunch_number_in_year(1776)
    end
  end

  def test_can_find_number_for_free_lunch
    ep = EconomicProfile.new({
      :name => "ACADEMY 20",
      :free_or_reduced_price_lunch => { 2014 =>
        { :percentage => 0.023,
          :total      => 100 }
      }
    })
    assert_in_delta 100, ep.free_or_reduced_price_lunch_number_in_year(2014), 0.005
  end

  def test_if_year_is_not_found_raise_unknown_data_error_for_title_i
    ep = EconomicProfile.new({
      :name => "ACADEMY 20",
      :title_i => { 2015 => 0.543 }
    })
    assert_raises(UnknownDataError) do
      ep.title_i_in_year(2020)
    end
  end

  def test_can_find_percentage_for_title_i
    ep = EconomicProfile.new({
      :name => "ACADEMY 20",
      :title_i => { 2015 => 0.543 }
    })
    assert_in_delta 0.543, ep.title_i_in_year(2015), 0.005
  end
end
