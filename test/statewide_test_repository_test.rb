require 'test_helper'
require 'statewide_test_repository'

class StatewideTestRepositoryTest < Minitest::Test
  def statewide_repo
    str = StatewideTestRepository.new
    str.load_data({
      :statewide_testing =>
        {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
      })
    str
  end

  def test_statewide_test_repo_class_exists
    str = StatewideTestRepository.new
    assert_equal StatewideTestRepository, str.class
  end

  def test_find_by_name_method_can_find_instance_of_statewide_test
    str = statewide_repo
    s = str.find_by_name("ACADEMY 20")
    assert_equal StatewideTest, s.class
    assert str.find_by_name("ACADEMY 20")
  end

  def test_find_by_name_method_returns_nil_if_district_doesnt_exist
    str = statewide_repo
    assert_nil str.find_by_name("ACADEMY pizza")
  end

end
