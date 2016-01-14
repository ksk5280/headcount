require 'enrollment'
require 'enrollment_repository'
require 'test_helper'

class EnrollmentRepositoryTest < Minitest::Test

  def test_it_can_take_in_a_file
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "test/fixtures/kindergarten_fixture.csv"
      }
    })
    assert_equal 2, er.enrollments.count
  end

  def test_it_can_find_by_name
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "test/fixtures/kindergarten_fixture.csv"
      }
    })
    district = er.find_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20", district.name
  end

  def test_it_can_find_by_name_lower_case_names
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "test/fixtures/kindergarten_fixture.csv"
      }
    })
    district = er.find_by_name("Colorado")
    assert_equal "COLORADO", district.name
  end

  def test_returns_nil_if_district_is_not_found
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "test/fixtures/kindergarten_fixture.csv"
      }
    })
    district = er.find_by_name("PIZZA")
    assert_nil district
  end

  def test_loads_participation_data_from_csv_for_enrollment_class
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "test/fixtures/kindergarten_fixture.csv"
      }
    })
    name = "COLORADO"
    enrollment = er.find_by_name(name)
    assert_equal name, enrollment.name
    assert enrollment.is_a?(Enrollment)
    assert_in_delta 0.741, enrollment.kindergarten_participation_in_year(2014), 0.005
  end
end
