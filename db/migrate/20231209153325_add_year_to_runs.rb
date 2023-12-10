class AddYearToRuns < ActiveRecord::Migration[7.1] # rubocop:disable Style/Documentation
  def change
    add_column :runs, :year, :integer
  end
end
