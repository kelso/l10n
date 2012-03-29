ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define do
  
  create_table :cars, :force => true do |t|
    t.string  :make
    t.string  :make_de
    t.string  :model
    t.string  :model_de
    t.decimal :price, :precision => 14, :scale => 2
    t.decimal :speed, :precision => 14, :scale => 2
  end
  
end