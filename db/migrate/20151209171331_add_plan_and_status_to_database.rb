class AddPlanAndStatusToDatabase < ActiveRecord::Migration
  def change
    add_column :users, :planID, :integer
    add_column :users, :accountStatus, :string
  end
end
