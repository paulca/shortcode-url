ActiveRecord::Schema.define(:version => 0) do
  create_table :test_models, :force => true do |t|
    t.string :shortcode_url
    t.string :other_field
    t.string :another_field
  end
end