class HomeController < ApplicationController
  require 'csv'
  require 'json'
  def index
  end

  def new
  end

  def create
    
    # unless File.exist?("Demo.json")
      # output = File.open("Demo.json","w")
    if input_params[:file].present?
      begin
        file = input_params[:file]
        output = JSON.pretty_generate(CSV.open(file.path, :headers => true).map { |x| x.to_h}) 
      rescue
        output = "invalid input"
      end
    end
        
      # else  
        # output = ''
      # output.close
    # end

    # file = File.open("Demo.json")
    # @output = file.read
    # file.close
    # p @output
    @output = output
    render 'new'
    # File.delete(file)
  end

  private
    def input_params
      params.permit(:input, :file)
    end
end
