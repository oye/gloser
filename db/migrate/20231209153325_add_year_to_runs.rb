class AddYearToRuns < ActiveRecord::Migration[7.1]
  def change
    add_column :runs, :year, :integer
  end
end
