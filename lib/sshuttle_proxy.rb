class SSHuttleProxy
  def initialize(region, options)
    @region = region
    @options = options
    AWSIPRanges.url = options[:aws_ip_url] if options[:aws_ip_url]
    @subnets = AWSIPRanges.subnets_for_region(@region)
  end

  def run
    command = build_command
    puts "Executing: #{command}"
    system(command)
  end

  private

  def build_command
    base_command = "sshuttle --dns -r #{@options[:ssh_host]}"
    additional_options = @options[:additional_options]
    subnets = @subnets.join(' ')
    
    [base_command, additional_options, subnets].compact.join(' ')
  end
end
