require 'test_helper'
require 'statewide_test'

class StatewideTestTest < Minitest::Test
  def statewide_repo
    str = StatewideTestRepository.new
    str.load_data({
      :statewide_testing =>
        {
        :third_grade => 'test/fixtures/grade_3_fixture.csv',
        :eighth_grade => 'test/fixtures/grade_8_fixture.csv',
        :math => 'test/fixtures/race_math_fixture.csv',
        :reading => 'test/fixtures/race_reading_fixture.csv',
        :writing => 'test/fixtures/race_writing_fixture.csv'
      }
      })
    str
  end

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

  def test_it_can_group_proficiency_by_grade
    str = statewide_repo
    expected = {
      2008 => {:math => 0.857, :reading => 0.866, :writing => 0.671},
      2009 => {:math => 0.824, :reading => 0.862, :writing => 0.706},
      2010 => {:math => 0.849, :reading => 0.864, :writing => 0.662},
      2011 => {:math => 0.819, :reading => 0.867, :writing => 0.678},
      2012 => {:math => 0.830, :reading => 0.870, :writing => 0.655},
      2013 => {:math => 0.855, :reading => 0.859, :writing => 0.668},
      2014 => {:math => 0.834, :reading => 0.831, :writing => 0.639}
    }
    testing = str.find_by_name("ACADEMY 20")
    expected.each do |year, data|
      data.each do |subject, proficiency|
        assert_in_delta proficiency, testing.proficient_by_grade(3)[year][subject], 0.005
      end
    end
  end

  def test_raises_unknown_data_error_for_unknown_grade
    str = statewide_repo
    testing = str.find_by_name("ACADEMY 20")

    assert_raises(UnknownDataError) do
      testing.proficient_by_grade(1)
    end
  end

  def test_can_group_proficiency_by_race
    str = statewide_repo
    testing = str.find_by_name("ACADEMY 20")
    expected = { 2011 => {math: 0.816, reading: 0.897, writing: 0.826},
                 2012 => {math: 0.818, reading: 0.893, writing: 0.808},
                 2013 => {math: 0.805, reading: 0.901, writing: 0.810},
                 2014 => {math: 0.800, reading: 0.855, writing: 0.789},
               }
    result = testing.proficient_by_race_or_ethnicity(:asian)
    expected.each do |year, data|
      data.each do |subject, proficiency|
        assert_in_delta proficiency, result[year][subject], 0.005
      end
    end

    expected = { 2011 => {math: 0.425, reading: 0.662, writing: 0.515},
                 2012 => {math: 0.425, reading: 0.695, writing: 0.504},
                 2013 => {math: 0.440, reading: 0.670, writing: 0.482},
                 2014 => {math: 0.421, reading: 0.704, writing: 0.519},
               }
    result = testing.proficient_by_race_or_ethnicity(:black)
    expected.each do |year, data|
      data.each do |subject, proficiency|
        assert_in_delta proficiency, result[year][subject], 0.005
      end
    end
  end

  def test_raises_unknown_race_error
    str = statewide_repo
    testing = str.find_by_name("ACADEMY 20")

    assert_raises(UnknownRaceError) do
      testing.proficient_by_race_or_ethnicity(:purple)
    end
  end
end
