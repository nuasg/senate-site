class AddDefaultToAffiliationEnabled < ActiveRecord::Migration[5.2]
  def change
    change_column_default :affiliations, :enabled, true
  end
end
