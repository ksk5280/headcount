require 'csv'
require 'set'
require 'district'
require 'data_loader'

class DistrictRepository
  attr_reader :districts


  def load_data(data)
    @districts = DataLoader.new.load_csv(data)
  end

  def find_by_name(name)
    if districts.include?(name=name.upcase)
      District.new({:name => name})
    else
      nil
    end
  end

  def find_all_matching(name_fragment)
    matching_districts = []
    districts.each do |district|
      if district.include?(name_fragment.upcase)
        matching_districts << district
      end
    end
    matching_districts
  end

end
