class CreateSessions < ActiveRecord::Migration[8.1]
  def change
    create_table :sessions, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :ip_address
      t.string :user_agent
      t.string :refresh_token
      t.datetime :expires_at, null: false

      t.timestamps
    end
    add_index :sessions, :refresh_token, unique: true
  end
end
