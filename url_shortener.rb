require 'aws-sdk-dynamodb'
require 'securerandom'

# AWS DynamoDB configuration
dynamodb = Aws::DynamoDB::Client.new(region: 'eu-central-1')

TABLE_NAME = 'url-shortener'

def shorten_url(dynamodb, long_url)
  short_code = SecureRandom.hex(4)
  dynamodb.put_item({
    table_name: TABLE_NAME,
    item: {
      'short_code' => short_code,
      'long_url' => long_url
    }
  })
  short_code
end

def expand_url(dynamodb, short_code)
  result = dynamodb.get_item({
    table_name: TABLE_NAME,
    key: { 'short_code' => short_code }
  })
  result.item ? result.item['long_url'] : nil
end

puts "Enter a long URL to shorten: "
long_url = gets.chomp
short_code = shorten_url(dynamodb, long_url)
puts "Shortened URL: #{short_code}"

puts "Enter the short code to expand: "
short_code_input = gets.chomp
expanded_url = expand_url(dynamodb, short_code_input)
puts "Expanded URL: #{expanded_url || 'No URL found for this code'}"
