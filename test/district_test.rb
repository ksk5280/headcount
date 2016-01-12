require 'district'
require 'test_helper'


class DistrictTest < Minitest::Test
  def test_it_has_a_name
    district = District.new({:name => "ACADEMY 20"})
    assert_equal "ACADEMY 20", district.name
  end
end
