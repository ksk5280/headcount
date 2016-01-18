require 'enrollment'
require 'enrollment_repository'
require 'test_helper'

class EnrollmentRepositoryTest < Minitest::Test

  def test_class_exists
    assert EnrollmentRepository
  end

  def test_load_data_creates_enrollment_hash
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "test/fixtures/kindergarten_fixture.csv"
      }
    })
    assert_equal Hash, er.enrollments.class
  end

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

  def test_it_can_find_another_name
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "test/fixtures/kindergarten_fixture.csv"
      }
    })
    district = er.find_by_name("COLORADO")
    assert_equal "COLORADO", district.name
  end

  def test_it_returns_nil_if_name_not_found
  er = EnrollmentRepository.new
  er.load_data({
    :enrollment => {
      :kindergarten => "test/fixtures/kindergarten_fixture.csv"
    }
  })
  assert_equal nil, er.find_by_name("PIZZA")
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

  def test_find_by_name_returns_an_enrollment_object
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "test/fixtures/kindergarten_fixture.csv"
      }
    })
    name = "COLORADO"
    enrollment = er.find_by_name(name)
    assert enrollment.is_a?(Enrollment)
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
    assert_in_delta 0.741, enrollment.kindergarten_participation_in_year(2014), 0.005
  end

  def test_enrollment_repository_is_able_to_load_high_school_data
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :high_school_graduation => "test/fixtures/small_hs_fixture.csv"
      }
    })
    data = er.enrollments['ACADEMY 20'].fetch(:high_school_graduation).fetch(2010)
    assert_equal 0.895, data
  end

  def test_can_load_both_kg_and_hs_data
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "test/fixtures/kindergarten_fixture.csv",
        :high_school_graduation => "test/fixtures/small_hs_fixture.csv"
      }
    })
    name = "COLORADO"
    enrollment = er.find_by_name(name)
    assert_equal name, enrollment.name
    assert_in_delta 0.741, enrollment.kindergarten_participation_in_year(2014), 0.005
    data = er.enrollments['ACADEMY 20'].fetch(:high_school_graduation).fetch(2010)
    assert_equal 0.895, data
  end

end
