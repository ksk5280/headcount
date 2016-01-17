require 'test_helper'
require 'statewide_test'

class StatewideTestTest < Minitest::Test
  def test_it_has_a_name
    st = StatewideTest.new({
      :name => "ACADEMY 20"
    })
    assert_equal "ACADEMY 20", st.name
  end

  def test_it_has_a_third_grade
    st = StatewideTest.new({
      :name => "ACADEMY 20",
      :third_grade => {
        2010 => 0.3915
      }
    })
    expected = {2010 => 0.3915}
    assert_equal expected, st.third_grade
  end

  def test_it_has_a_eighth_grade
    st = StatewideTest.new({
      :name => "ACADEMY 20",
      :eighth_grade => {
        2010 => 0.3915
      }
    })
    expected = {2010 => 0.3915}
    assert_equal expected, st.eighth_grade
  end

  def test_it_has_math_hash
    st = StatewideTest.new({
      :name => "ACADEMY 20",
      :math => {
        2010 => 0.3915
      }
    })
    expected = {2010 => 0.3915}
    assert_equal expected, st.math
  end

  def test_it_has_reading_hash
    st = StatewideTest.new({
      :name => "ACADEMY 20",
      :reading => {
        2010 => 0.3915
      }
    })
    expected = {2010 => 0.3915}
    assert_equal expected, st.reading
  end

  def test_it_has_writing_hash
    st = StatewideTest.new({
      :name => "ACADEMY 20",
      :writing => {
        2010 => 0.3915
      }
    })
    expected = {2010 => 0.3915}
    assert_equal expected, st.writing
  end
end
