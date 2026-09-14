class RenameGroupNgConditionsToGroupAvoidConditions < ActiveRecord::Migration[7.2]
  def change
    rename_table :group_ng_conditions, :group_avoid_conditions
  end
end
