class AddReadAuditsToRole < ActiveRecord::Migration
  def change
    add_column :roles, :read_audits, :boolean, default: false
  end
end
