require 'economic_profile'
require 'economic_profile_repository'
require 'test_helper'

class EconomicProfileTest < Minitest::Test
  def test_it_has_a_name
    ep = EconomicProfile.new({
      :name => "ACADEMY 20",
    })
    assert_equal "ACADEMY 20", ep.name
  end
end
