class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.string :email
      t.string :invite_token
      t.boolean :active, default: true
      t.datetime :last_sent_time
      
      t.timestamps null: false
    end
  end
end
