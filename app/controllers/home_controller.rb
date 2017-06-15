class HomeController < ApplicationController
  require 'csv'
  require 'json'
  def index
  end

  def new
  end

  def create
    @output = ""
    @json = ""
    csv_str = input_params[:input]
    CSV.parse(csv_str) do |row| 
      # puts " #{row[0]}#{row[1]}#{row[2]} #{row[3]}#{row[4]}" 
      unless row.empty?
        unless row[0].nil?
          @post = row[0]
          @api = row[1]
          if @json.empty?
            @json += "\n{\n  \"#{row[3]}\" : \"#{row[4]}\""
          end
          else
            @json +=  ",\n  \"#{row[3]}\" : \"#{row[4]}\""
          end   
      else
        @json += "\n}"
        @output += "METHOD:   " + @post + "\n" + "API_URL:   " + @api + "\n" + "JSON :" + @json + "\n\n"
        @json = ""
      end
    end 
   @output

    # if input_params[:file].present?
    #   begin
    #     file = input_params[:file]
    #     output = JSON.pretty_generate(CSV.open(file.path, :headers => true).map { |x| x.to_h}) 
    #   rescue
    #     output = "invalid input"
    #   end
    # end

    render 'new'
  end

  private
    def input_params
      params.permit(:input, :file)
    end
end
