require 'district'
require 'test_helper'


class DistrictTest < Minitest::Test
  def test_it_has_a_name
    district = District.new({:name => "ACADEMY 20"})
    assert_equal "ACADEMY 20", district.name
  end

  def test_it_has_enrollments
    district = District.new({
      :name => "ACADEMY 20",
      :enrollment => { 2010 => 0.436,
                       2011 => 0.489,
                       2012 => 0.479}}
    )
    expected = {2010=>0.436, 2011=>0.489, 2012=>0.479}
    actual = district.enrollment
    assert_equal expected, actual
  end
end
