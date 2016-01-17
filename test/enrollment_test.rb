require 'enrollment'
require 'enrollment_repository'
require 'test_helper'

class EnrollmentTest < Minitest::Test
  def test_it_has_a_name
    e = Enrollment.new({
      :name => "ACADEMY 20",
      :kindergarten_participation => {
        2010 => 0.3915,
        2011 => 0.35356,
        2012 => 0.2677
      }
    })
    assert_equal "ACADEMY 20", e.name
  end

  def test_it_has_a_hash_of_participation_data
    e = Enrollment.new({
      :name => "ACADEMY 20",
      :kindergarten_participation => {
        2010 => 0.3915,
        2011 => 0.35356,
        2012 => 0.2677
      }
    })
    expected = {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}
    assert_equal expected, e.kindergarten_participation
  end

  def test_kindergarten_returns_a_hash_of_years_as_keys_and_3_digit_float_as_value
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "test/fixtures/kindergarten_fixture.csv"
      }
    })
    district = er.find_by_name("ACADEMY 20")
    expected = {2007=>0.392}
    assert_equal expected, district.kindergarten_participation_by_year
  end

  def test_kindergarten_returns_a_truncated_value_for_specific_year
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "test/fixtures/kindergarten_fixture.csv"
      }
    })
    district = er.find_by_name("ACADEMY 20")
    assert_equal 0.392, district.kindergarten_participation_in_year(2007)
  end

  def test_can_find_high_school_graduation_by_year
    e = Enrollment.new({
      :name => "ACADEMY 20",
      :high_school_graduation => {
        2010 => 0.895,
        2011 => 0.895,
        2012 => 0.88983
      }
    })
    expected = { 2010 => 0.895, 2011 => 0.895, 2012 => 0.890 }
    assert_equal expected, e.graduation_rate_by_year
  end

  def test_can_find_high_school_graduation_in_year
    e = Enrollment.new({
      :name => "ACADEMY 20",
      :high_school_graduation => {
        2010 => 0.895,
        2011 => 0.895,
        2012 => 0.88983
      }
    })
    assert_equal 0.895, e.graduation_rate_in_year(2010)
  end
end
