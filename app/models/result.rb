class Result < ApplicationRecord
end

# == Schema Information
#
# Table name: results
#
#  id               :bigint(8)        not null, primary key
#  link_id          :string           not null
#  rappi_result     :float
#  uber_eats_result :float
#  uber_result      :float
#  total_result     :float
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_results_on_link_id  (link_id) UNIQUE
#
