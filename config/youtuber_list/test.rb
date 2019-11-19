require 'csv'
Encoding.default_external = 'utf-8'

CSV.foreach('youtuber_next_data.csv') do |test|
  p test
  test[3].each do |data|
    p data
  end
end