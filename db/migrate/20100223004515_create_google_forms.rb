class CreateGoogleForms < ActiveRecord::Migration
  def self.up
    create_table :google_forms do |t|
      t.string :slug
      t.string :title
      t.string :formkey
      t.text :thank_you_message
      t.timestamps
    end
  end

  def self.down
    drop_table :google_forms
  end
end
