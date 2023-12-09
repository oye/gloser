class AddYearToWords < ActiveRecord::Migration[7.1]
  def change
    add_column :words, :year, :integer
  end
end
