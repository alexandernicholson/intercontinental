require 'net/http'
require 'json'

class AWSIPRanges
  URL = 'https://ip-ranges.amazonaws.com/ip-ranges.json'

  def self.fetch
    response = Net::HTTP.get(URI(URL))
    JSON.parse(response)
  end

  def self.subnets_for_region(region)
    ip_ranges = fetch
    if region.downcase == 'all'
      ip_ranges['prefixes'].map { |prefix| prefix['ip_prefix'] }.uniq
    else
      ip_ranges['prefixes'].select { |prefix| prefix['region'] == region }.map { |prefix| prefix['ip_prefix'] }
    end
  end
end
