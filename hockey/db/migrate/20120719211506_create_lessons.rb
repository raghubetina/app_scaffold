class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.string :name
      t.string :embed_code
      t.integer :user_id

      t.timestamps
    end
  end
end
