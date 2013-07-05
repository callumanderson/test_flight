require 'test_flight/version'
require 'rubygems'
require 'httparty'
require 'rest-client'

module TestFlight
  class Uploader
    def initialize(input=STDIN, output=STDOUT)
      @input = input, @output = output
    end

    #Method to get parameters for the post_app call from the user in the command line
    def start_post
      request_file_path
      ipa_file_path = get_file_path
      request_notes
      release_notes = get_notes
      distribution_list = get_distribution_list #calls the fetch && confirm methods
      post_app(get_conf('end_point'), get_conf('api_key'), get_conf('team_key'), ipa_file_path, release_notes, distribution_list)
  end

    def post_app(end_point, api_token, team_token, ipa_file_path, release_notes, distribution_list)
      @output.puts "POSTing application to TestFlight."
      ipa_file = File.new(ipa_file_path)

      payload = {
          :api_token => api_token,
          :team_token => team_token,
          :file => ipa_file,
          :notes => release_notes,
          :distribution_list => distribution_list,
      }

      begin
        response = RestClient.post(end_point, payload, :accept => :json)
      rescue => e
        response = e.response
      end

      if response.code == 200
        @output.puts "Done POSTing application to TestFlight."
        @output.puts response.body
      else
        @output.puts "POST failed with response code #{response.code}"
        @output.puts response.body
      end
    end

    def get_conf(key)
      file = get_file
      conf_value = file.fetch(key)
      if conf_value
        conf_value
      else
        @output.puts "No value for #{key} found in yaml, please enter one: "
        value = @input[0].gets
        file = get_file
        file[key] = value
        file.fetch(key)
      end
    end

    def get_file
      fn = File.dirname(File.expand_path(__FILE__)) + '/../config/test_flight_config.yml'
      YAML::load(File.open(fn))
    end

    def request_file_path
       @output.puts("Enter the file path to the ipa: ")
    end

    def get_file_path
      @input[0].gets.delete("\n")
    end

    def get_distribution_list
      print_distribution_list
      input = check_distribution_list
      fetch_default_dist unless input !=~ /[yY]/
    end

    def check_distribution_list
      @output.puts "Please enter 'y' to confirm this distribution list"
      @input[0].gets
    end

    def print_distribution_list
      @output.puts("Default distribution list is: #{fetch_default_dist.to_s}")
    end

    def fetch_default_dist
      get_conf('dist_list')
    end

    def request_notes
      @output.puts("Please enter build notes:")
    end

    def get_notes
      @input[0].gets
    end

  end
end
