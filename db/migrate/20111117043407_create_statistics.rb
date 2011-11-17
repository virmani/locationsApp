class CreateStatistics < ActiveRecord::Migration
  def change
    create_table :statistics do |t|
      t.string :status_code
      t.integer :count
      t.float :average
      t.float :variance

      t.timestamps
    end
  end
end
