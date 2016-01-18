require 'economic_profile'
require 'economic_profile_repository'
require 'test_helper'

class EconomicProfileTest < Minitest::Test
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
end
