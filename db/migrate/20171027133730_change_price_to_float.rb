class ChangePriceToFloat < ActiveRecord::Migration
  def change
    change_column :budget_headings, :price, :float
  end
end
