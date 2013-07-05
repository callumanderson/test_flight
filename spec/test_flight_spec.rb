require_relative 'spec_helper.rb'

describe 'TestFlight::Uploader' do
  before(:each) do
    @input = StringIO.new
    @output = StringIO.new
    @uploader = TestFlight::Uploader.new(@input, @output)
  end

  describe 'get_conf' do
    it 'should return the endpoint from the configuration file' do
      @uploader.get_conf('test_end_point').should eq("test_end_point")
    end

    it 'should return the api key from the configuration file' do
      @uploader.get_conf('test_api_key').should eq("test_api_key")
    end

    it 'should fail if an invalid key is supplied' do
      expect{@uploader.get_conf('invalid_key')}.to raise_error(KeyError)
    end

    it 'should request values when they are not present' do
      @uploader.get_conf("blank_key")
      @output.seek(0)
      @output.read.should eq("No value for blank_key found in yaml, please enter one: \n")
    end

    it 'should populate values from user input' do
      @uploader.get_conf("blank_key")
      @input.print("value_for_blank_key")
      @input.rewind
      @uploader.get_conf("blank_key").should eq("value_for_blank_key")
    end
  end

  describe 'ipa filepath' do
    describe 'request_filepath' do
    it 'should request the filepath from the user' do
      @uploader.request_file_path
      @output.seek(0)
      @output.read.should eq("Enter the file path to the ipa: \n")
    end
  end

  describe 'return_filepath' do
    it 'should return the entered filepath' do
      @input.puts "/path/to/app.ipa"
      @input.rewind
      result = @uploader.get_file_path
      result.should eq("/path/to/app.ipa")
    end
  end
  end

  describe 'distribution_list' do
    it 'should fetch the default list from yaml' do
      expectations = ["<YOUR EMAIL HERE>"]
      @uploader.fetch_default_dist.should eq(expectations)
    end

    it 'should confirm with the user' do
      @uploader.check_distribution_list
      @output.seek(0)
      @output.read.should eq("Please enter 'y' to confirm this distribution list\n")
    end

    it 'should return the user input' do
      @input.puts("y")
      @input.rewind
      result = @uploader.check_distribution_list
      result.should eq("y\n")
    end

    it 'should print the dist list' do
      expectation = "Default distribution list is: [\"<YOUR EMAIL HERE>\"]\n"
      @uploader.print_distribution_list
      @output.seek(0)
      @output.read.should eq(expectation)
    end
  end

  describe 'file operations' do
    it 'should find the file from the supplied path' do
      file = File.dirname(File.expand_path(__FILE__)) + '/../test/data/test_ipa.ipa'
      file.class.name.should eq("String")
      @input.puts(file)
      @input.rewind
      file_path = @uploader.get_file_path
      result = File.exists? file_path
      result.should eq(true)
    end
  end

  describe 'build notes' do
    it 'should request build notes from the user' do
      @uploader.request_notes
      @output.seek(0)
      @output.read.should eq("Please enter build notes:\n")
    end
    it 'should fetch the build notes from input' do
      @input.puts("some build notes")
      @input.rewind
      @uploader.get_notes.should eq("some build notes\n")
    end
  end
 end
