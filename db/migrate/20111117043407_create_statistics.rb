class CreateStatistics < ActiveRecord::Migration
  def change
    create_table :statistics do |t|
      t.string :status_code # one row for each response status code class i.e. 2xx, 3xx, 4xx, 5xx
      t.integer :count      # Current running total number of requests
      t.float :average      # Current average of the response status codes grouped by their class (2xx, 4xx, etc).
      t.float :variance     # Current variance of the response status codes grouped by their class (2xx, 4xx, etc).

      t.timestamps
    end
  end
end
