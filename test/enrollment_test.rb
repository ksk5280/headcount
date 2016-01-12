require 'enrollment'
require 'test_helper'

class EnrollmentTest < Minitest::Test
  def test_it_has_a_name
    e = Enrollment.new({:name => "ACADEMY 20",
                             :kindergarten_participation => {
                               2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677
                            }})
    assert_equal "ACADEMY 20", e.name
  end

  def test_it_has_a_hash_of_participation_data
    e = Enrollment.new({:name => "ACADEMY 20",
                             :kindergarten_participation => {
                               2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677
                            }})
    expected = {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}
    assert_equal expected, e.kindergarten_participation
  end

  def test_kindergarten_returns_a_hash_of_years_as_keys_and_3_digit_float_as_value
    e = Enrollment.new({:name => "ACADEMY 20",
                             :kindergarten_participation => {
                               2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677
                            }})
    expected = {2010 => 0.391, 2011 => 0.353, 2012 => 0.267}
    assert_equal expected, e.kindergarten_participation_by_year
  end

  def test_kindergarten_returns_a_truncated_value_for_specific_year
    e = Enrollment.new({:name => "ACADEMY 20",
                             :kindergarten_participation => {
                               2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677
                            }})
    assert_equal 0.391, e.kindergarten_participation_in_year(2010)
  end

end