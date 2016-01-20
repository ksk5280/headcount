require_relative 'economic_profile'
require_relative 'data_loader'

class EconomicProfileRepository
  # include RepoHelper
  attr_reader :economic_profiles

  # def initialize
  #   @base_klass = EconomicProfile
  # end

  # def base_class_hash
  #   {
  #     :median_household_income => repository.fetch(name)[:median_household_income],
  #     :children_in_poverty => repository.fetch(name)[:children_in_poverty],
  #     :free_or_reduced_price_lunch => repository.fetch(name)[:free_or_reduced_price_lunch],
  #     :title_i => repository.fetch(name)[:title_i]
  #   }
  # end

  def load_data(data)
    @economic_profiles = DataLoader.new.load_economic_csv(data)
    #@economic_profiles = DataLoader.load(:economic_profiles => data)
  end

  def find_by_name(name)
    name = name.upcase
    if economic_profiles.has_key?(name)
      EconomicProfile.new({
        :name => name,
        :median_household_income => economic_profiles.fetch(name)[:median_household_income],
        :children_in_poverty => economic_profiles.fetch(name)[:children_in_poverty],
        :free_or_reduced_price_lunch => economic_profiles.fetch(name)[:free_or_reduced_price_lunch],
        :title_i => economic_profiles.fetch(name)[:title_i]
      })
    end
  end
end

# module RepoHelper
#   def find_by_name(name)
#     name = name.upcase
#     if economic_profiles.has_key?(name)
#       base_class_hash[:name] = name
#       @base_class.new(base_class_hash)
#     end
#   end
# end
