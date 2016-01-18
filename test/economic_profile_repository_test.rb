require 'economic_profile'
require 'economic_profile_repository'
require 'test_helper'

class EconomicProfileRepositoryTest < Minitest::Test
  def economic_profile_repository
    epr = EconomicProfileRepository.new
    epr.load_data({
      :economic_profile => {
        :median_household_income => "test/fixtures/median_income_fixture.csv",
        :children_in_poverty => "test/fixtures/poverty_fixture.csv",
        :free_or_reduced_price_lunch => "test/fixtures/free_lunch_fixture.csv",
        :title_i => "test/fixtures/title_i_fixture.csv"
      }
    })
    epr
  end

  def test_economic_profile_repo_class_exists
    epr = EconomicProfileRepository.new
    assert_equal EconomicProfileRepository, epr.class
  end

  def test_raises_error_if_files_are_not_valid_csv_files
    epr = EconomicProfileRepository.new
    assert_raises(InvalidFileError) do
      epr.load_data({
        :economic_profile => {
          :median_household_income => "test/pizza.csv",
        }
      })
    end
  end

meta t: true
  def test_can_load_a_file
    epr = economic_profile_repository
    assert_equal 5, epr.economic_profile.count
  end

  def test_can_find_by_name
    epr = economic_profile_repository
    ep = epr.find_by_name('ACADEMY 20')
    assert_equal 'ACADEMY 20', ep.name
  end

  def test_find_by_name_is_case_insensitive
    epr = economic_profile_repository
    ep = epr.find_by_name('Academy 20')
    assert_equal EconomicProfile, ep.class
  end

  def test_find_by_name_creates_economic_profile_instance
    epr = economic_profile_repository
    ep = epr.find_by_name('ACADEMY 20')
    assert_equal EconomicProfile, ep.class
  end

  def test_returns_nil_if_district_name_is_not_found
    epr = economic_profile_repository
    assert_nil epr.find_by_name('Academy centaur')
  end
end
