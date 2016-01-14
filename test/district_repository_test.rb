require 'district_repository'
require 'test_helper'

class DistrictRepositoryTest < Minitest::Test
  def test_it_can_take_in_a_file
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "test/fixtures/kindergarten_fixture.csv"
      }
    })
    assert_equal 2, dr.districts.count
  end

  def test_it_can_find_by_name
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "test/fixtures/kindergarten_fixture.csv"
      }
    })
    district = dr.find_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20", district.name
  end

  def test_it_can_find_by_name_lower_case_names
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "test/fixtures/kindergarten_fixture.csv"
      }
    })
    district = dr.find_by_name("Colorado")
    assert_equal "COLORADO", district.name
  end

  def test_find_by_name_returns_nil_if_district_is_not_found
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "test/fixtures/kindergarten_fixture.csv"
      }
    })
    district = dr.find_by_name("PIZZA")
    assert_nil district
  end

  def test_it_can_find_by_name_and_create_an_instance_of_an_object
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "test/fixtures/kindergarten_fixture.csv"
      }
    })
    district = dr.find_by_name("ACADEMY 20")
    msg = "Expected district to be a class of District"
    assert district.instance_of?(District), msg
  end

  def test_finds_all_matching_districts_using_name_fragment
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "test/fixtures/kindergarten_fixture.csv"
      }
    })
    district_array = dr.find_all_matching("ACA")
    assert_equal ["ACADEMY 20"], district_array
  end

  def test_returns_empty_array_if_no_matches_are_found
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "test/fixtures/kindergarten_fixture.csv"
      }
    })
    district_array = dr.find_all_matching("dsfas")
    assert_equal [], district_array
  end

  def test_finds_all_matching_districts_using_lowercase_name_fragment
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "test/fixtures/kindergarten_fixture.csv"
      }
    })
    district_array = dr.find_all_matching("aca")
    assert_equal ["ACADEMY 20"], district_array
  end

  def test_result_is_upcased_even_if_original_location_is_not
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "test/fixtures/kindergarten_fixture.csv"
      }
    })
    district_array = dr.find_all_matching("colo")
    assert_equal ["COLORADO"], district_array
  end

  def test_that_enrollment_repo_instance_is_created_when_data_is_loaded
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "test/fixtures/kindergarten_fixture.csv"
      }
    })
    assert_equal EnrollmentRepository, dr.enrollment_repository.class
  end
end
