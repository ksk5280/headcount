require 'district'
require 'test_helper'


class DistrictTest < Minitest::Test
  def test_it_has_a_name
    district = District.new({:name => "ACADEMY 20"})
    assert_equal "ACADEMY 20", district.name
  end

  def test_can_initialize_with_enrollments
    skip
    district = District.new({:name => "ACADEMY 20"}, :enrollment => enrollment_repository.find_by_name("ACADEMY 20"))
    expected = "something"
    actual = "something else"
    assert_equal expected, actual
  end
end
