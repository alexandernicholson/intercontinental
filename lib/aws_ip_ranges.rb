require 'net/http'
require 'json'
require 'fileutils'

class AWSIPRanges
  CACHE_DIR = 'cache'
  JSON_FILE = File.join(CACHE_DIR, 'ip-ranges.json')
  ETAG_FILE = File.join(CACHE_DIR, 'ip-ranges.etag')
  DEFAULT_URL = 'https://ip-ranges.amazonaws.com/ip-ranges.json'

  class << self
    attr_writer :url

    def url
      @url ||= DEFAULT_URL
    end

    def fetch
      FileUtils.mkdir_p(CACHE_DIR)

      uri = URI(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = (uri.scheme == 'https')

      request = Net::HTTP::Get.new(uri)
      request['If-None-Match'] = File.read(ETAG_FILE) if File.exist?(ETAG_FILE)

      response = http.request(request)

      case response.code
      when '304'
        JSON.parse(File.read(JSON_FILE))
      when '200'
        File.write(ETAG_FILE, response['ETag'])
        json_data = response.body
        File.write(JSON_FILE, json_data)
        JSON.parse(json_data)
      else
        if File.exist?(JSON_FILE)
          JSON.parse(File.read(JSON_FILE))
        else
          raise "Failed to fetch IP ranges and no cache available"
        end
      end
    end

    def subnets_for_region(region)
      ip_ranges = fetch
      if region.downcase == 'all'
        ip_ranges['prefixes'].map { |prefix| prefix['ip_prefix'] }.uniq
      else
        ip_ranges['prefixes'].select { |prefix| prefix['region'] == region }.map { |prefix| prefix['ip_prefix'] }
      end
    end
  end
end
