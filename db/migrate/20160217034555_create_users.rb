class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :uid
      t.string :provider
      t.string :email
      t.string :image_url
      t.string :token
      t.string :name

      t.timestamps null: false
    end
  end
end
