require 'district_repository'
require 'test_helper'

class DistrictRepositoryTest < Minitest::Test

  def test_it_can_take_in_a_file
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {
                    :kindergarten => "test/fixtures/kindergarten_fixture.csv"}
                  })
    assert_equal 2, dr.districts.count
  end

  def test_it_can_find_by_name
    skip
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {
                    :kindergarten => "test/fixtures/kindergarten_fixture.csv"}
                  })
    district = dr.find_by_name("ACADEMY 20")
    assert_equal
  end

end
