class HomeController < ApplicationController
  require 'csv'
  require 'json'
  def index
  end

  def new
  end

  def create
    #  if input_params[:file].present?
    #   begin
    #     file = input_params[:file]
    #     (CSV.open(file.path, :headers => true).map { |x| x.to_h}) 
    #   rescue
    #     output = "invalid input"
    #   end
    # end

    @csv_str = ""
    @output = ""
    @json = ""

    if input_params[:file].present?
      file = input_params[:file]
      if File.extname(file.path) == ".csv"
        @csv_str = File.read(file.path)
        @csv_str = @csv_str.gsub(/\n/, "\r\n")
      else
          @output = "INVALID FORMAT"
      end
    else
       @csv_str = input_params[:input] + "\r\n\r\n"
    end
    unless @csv_str.empty? 
      input_params[:apiURL].present?? @api_url = input_params[:apiURL] + '/' : @api_url = "http://trial-api.ex-cloud.biz/v1/"
      puts "***********"
      puts @csv_str.inspect
      puts "***********"
          
      @csv_str = @csv_str.gsub(/[\r\n]{3,}/, "\r\n\r\n")
      
      puts "***********"
      puts @csv_str.inspect
      puts "***********"

      begin
        CSV.parse(@csv_str) do |row| 
          puts " #{row[0]}#{row[1]}#{row[2]} #{row[3]}#{row[4]}" 
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
            unless @post.nil?
            @json += "\n}"
            @output += "METHOD:   " + @post + "\n" + "API_URL:   " + @api_url + @api + "\n" + "JSON :" + @json + "\n\n"
            @json = ""
            end
          end
        end 
        rescue
          @output = "INVALID FORMAT"
        end
    end
    render 'new'
  end

  private
    def input_params
      params.permit(:input, :file, :apiURL)
    end
end
