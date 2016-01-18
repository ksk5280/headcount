$LOAD_PATH.unshift(File.expand_path('.',__dir__))
require 'enrollment_repository'
require 'pry'

class Enrollment
  attr_reader :name,
              :kindergarten_participation,
              :high_school_graduation

  def initialize(data)
    @name = data[:name].upcase
    @kindergarten_participation =
      data[:kindergarten_participation]
    @high_school_graduation =
      data[:high_school_graduation]
  end

  def kindergarten_participation_by_year
    kindergarten_participation
    # returns a hash with keys as years and values as truncated percentage
  end

  def kindergarten_participation_in_year(year)
    kindergarten_participation_by_year.fetch(year)
  end

  def graduation_rate_by_year
    high_school_graduation.each do |k, v|
      high_school_graduation[k] = v.round(3)
    end
  end

  def graduation_rate_in_year(year)
    graduation_rate_by_year.fetch(year)
  end
end

if __FILE__ == $0
  er = EnrollmentRepository.new
  er.load_data({
    :enrollment => {
      :kindergarten => "test/fixtures/small_kg_fixture.csv",
      :high_school_graduation => "test/fixtures/small_hs_fixture.csv"
    }
  })
  er.find_by_name('COLORADO')
end
