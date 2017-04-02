#!/usr/bin/env ruby

require 'yaml'
require 'optparse'
require 'pp'
require 'fileutils'

@script_version = '1.0.0'

# Parse Arguments/Options
@options = Hash.new

# Defaults
@options['dockerfile_path'] = 'Dockerfile'
@options['build_path'] = '.'

ARGV << '-h' if ARGV.empty?

options_parser = OptionParser.new do |opts|
  opts.banner = 'Usage: bdi.rb -c examples/chef.yml [OPTIONS]'
  opts.separator ''
  opts.separator 'Options:'
  opts.on('-c', '--config FULLNAME', '(Required) Full Path to YAML Account Config') do |opt|
    @options['config_yaml'] = opt
  end
  opts.on('-f', '--dockerfile-path', '(Optional) Path to Dockerfile. Default is Current working Directory.') do |opt|
    @options['dockerfile_path'] = opt
  end
  opts.on('-b', '--build-path', '(Optional) Build Path or URL. Default is Current working Directory (.).') do |opt|
    @options['build_path'] = opt
  end
  opts.on('-t', '--tags', '(Optional) No Space Comma Separated Image Tags. Default is None.') do |opt|
    @options['tags'] = opt
  end
  opts.on('-e', '--extra-args', '(Optional) To pass additional docker build arguments. This is a string so put in quotes. Default is None.') do |opt|
    @options['extra_args'] = opt
  end
  opts.on('-h', '--help', '(Flag) Show this message') do
    puts opts
    exit 0
  end
  opts.on('-v', '--version', '(Flag) Output Script Version') do
    puts "Build Docker Image v#{@script_version}"
    exit 0
  end
end
options_parser.parse(ARGV)

# Output Methods
def show_message(message, type = nil)
  case type
  when 'info'
    puts "INFO: #{message}"
  when 'results'
    puts "RESULTS: #{message}"
  when 'error'
    puts ''
    puts "ERROR: #{message}"
    puts ''
    raise
  else
    puts message
  end
end

def show_info(message)
  show_message(message, 'info')
end

def show_results(message)
  show_message(message, 'results')
end

def show_error(message)
  show_message(message, 'error')
end

def show_header
  show_message '******** STARTING DOCKER IMAGE BUILD ********'
  system 'clear' unless system 'cls'
  show_message "Build Docker Image v#{@script_version}  |  Ruby v#{RUBY_VERSION}  |  by Levon Becker"
  show_message '--------------------------------------------------------------------------------'
  show_message "YAML CONFIG:  (#{@options['config_yaml']})"
  show_message '--------------------------------------------------------------------------------'
end

def show_sub_header(message)
  show_header
  show_message message
  show_message '--------------------------------------------------------------------------------'
  show_message ''
end

def show_footer(start_time, end_time, run_time)
  show_results "Start Time:        #{start_time}"
  show_results "End Time:          #{end_time}"
  show_results "Run Time:          #{run_time}"
  show_sub_header 'COMPLETED!'
  show_message '******** FINISHED DOCKER IMAGE BUILD ********'
end

def time_diff(start_time, end_time)
  Time.at((start_time - end_time).round.abs).utc.strftime('%H:%M:%S')
end

def debug_output(bash_command, std_out, std_err)
  show_message '** DEBUG OUTPUT **'
  show_message "Build Docker Image v#{@script_version}"
  show_message "Yaml Config Path:  (#{@options['config_yaml']})"
  show_message "Dockerfile Path:   (#{@options['dockerfile_path']})"
  show_message "Build path:        (#{@options['build_path']})"
  show_message "Bash Command:      (#{bash_command})"
  show_message "Standard Out:      (#{std_out})"
  show_message "Standard Error:    (#{std_err})"
  raise 'Failed!'
end

# Meat and Potatoes
def load_config_yaml
  show_sub_header 'Parsing Configuration YAML'
  @yaml_config = YAML.load_file(File.open((@options['config_yaml']).to_s, 'r'))
  show_info 'Completed Configuration YAML Parsing'
end

def parse_args
  show_sub_header 'Parsing Build Arguments'
  @args_string = String.new
  @yaml_config.each do |key, value|
    @args_string << " --build-arg '#{key}=#{value}'"
  end
end

def parse_tags
  show_sub_header 'Parsing Tags'
  return if @options['tags'].nil?
  @tags_list = @options['tags'].split(',')
  @tags_list.each do |tag|
    @tags_string << " -t #{tag}"
  end
end

def build_image
  show_sub_header 'Building Image'
  # Run Bash Script and Capture StrOut, StrErr, and Status
  bash_command = "docker build --force-rm #{@options['extra_args']}#{@args_string} -f #{@options['dockerfile_path']}#{@tags_string} #{@options['build_path']}"

  require 'open3'
  out, err, status = Open3.capture3(bash_command)
  show_message "Open3: Status (#{status})"
  return if status.success?
  debug_output(bash_command, out, err)
end

# Run List
def run_list
  @start_time = Time.now
  show_header
  load_config_yaml
  parse_args
  parse_tags
  build_image
  @end_time = Time.now
  @run_time = time_diff(@start_time, @end_time)
  show_footer(@start_time, @end_time, @run_time)
end

run_list
