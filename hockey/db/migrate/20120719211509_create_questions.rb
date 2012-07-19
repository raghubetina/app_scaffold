class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :content
      t.integer :lesson_id

      t.timestamps
    end
  end
end
