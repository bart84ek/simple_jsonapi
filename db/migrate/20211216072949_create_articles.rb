class CreateArticles < ActiveRecord::Migration[6.1]
  def change
    create_table :articles do |t|
      t.text :title
      t.references :author, null: false, foreign_key: true

      t.timestamps
    end
  end
end
