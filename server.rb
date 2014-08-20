require 'sinatra'
require 'csv'
require 'pry'

def read_csv(filename)
  data = []
  CSV.foreach(filename, headers: true) do |row|
    data << row.to_hash
  end
  data
end

def country_names(data)
  country_names = []
  data.each do |countries|
    country_names << countries["Country"]
  end
  country_names
end

def country_data(data, country_name)
  country_info = data.select { |country| country_name == country["Country"]}
  country_info.first
end

before do
  # Array of Hashes of country information
  # ||= operator allows for data to only be loaded into memory once
  @data ||= read_csv('data.csv')
end

get '/countries' do
  search = params["name_of_country"]
  if search
    #Ugly
    @country_names = country_names(@data).select { |country| search == country }
  else
    @country_names = country_names(@data)
  end
  erb :index
end

get '/countries/:country_name' do
  country_name = params[:country_name]
  @country_data = country_data(@data, country_name)

  erb :show
end



# These lines can be removed since they are using the default values. They've
# been included to explicitly show the configuration options.
set :views, File.dirname(__FILE__) + '/views'
set :public_folder, File.dirname(__FILE__) + '/public'
