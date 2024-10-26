require 'optparse'

class CLI
  def self.parse(args)
    options = {}
    parser = OptionParser.new do |opts|
      opts.banner = "Usage: #{$PROGRAM_NAME} [options]"

      opts.on("-r", "--region REGION", "AWS region (use 'all' for all regions)") { |v| options[:region] = v }
      opts.on("-s", "--ssh-host HOST", "SSH host to connect through") { |v| options[:ssh_host] = v }
      opts.on("-o", "--options OPTIONS", "Additional sshuttle options") { |v| options[:additional_options] = v }
    end

    parser.parse!(args)
    options
  end
end
