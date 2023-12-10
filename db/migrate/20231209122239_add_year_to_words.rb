class AddYearToWords < ActiveRecord::Migration[7.1] # rubocop:disable Style/Documentation
  def change
    add_column :words, :year, :integer
  end
end
