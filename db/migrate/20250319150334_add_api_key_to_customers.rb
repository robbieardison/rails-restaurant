class AddApiKeyToCustomers < ActiveRecord::Migration[6.1]
  def change
    add_column :customers, :api_key, :string
    add_index :customers, :api_key, unique: true
  end
end