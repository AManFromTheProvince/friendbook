class AddInfoToComments < ActiveRecord::Migration[6.0]
  def change
    add_column :comments, :comment_text, :string
  end
end
