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
        @csv_str = @csv_str.gsub(/\t/, ",")
        puts @csv_str.inspect
        puts "###############################"
      else
          @output = "INVALID FORMAT"
      end
    else
       @csv_str = input_params[:input] + "\r\n\r\n"
       @csv_str = @csv_str.gsub(/\t/, ",")
    end
    unless @csv_str.empty? 
      @csv_str = @csv_str + "\nEnd"
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
              if !@post.nil? 
                @json += "\n\t],\n],"
                @output += "[\n\t'method' => '" + @post.downcase + "',\n\t" + "'api' => '" + @api + "',\n\t" + "'data' => " + @json + "\n\n"
                @json = ""
                @post = nil
              end
              if @post.nil?
                @post = row[0]
                @api = row[1]
                if @json.empty? 
                  @json += "\t[\n\t  '#{row[3]}' => '#{row[4]}',"
                end 
              end   
            else
              @json +=  "\n\t  '#{row[3]}' => '#{row[4]}',"
            end
          end
        end
      rescue
        raise
        @output = "INVALID FORMAT"
      end
    end
    @output = "<?php\nreturn ['data' =>\n[\n" + @output +"]\n];"
    render 'new'
  end

  private
    def input_params
      params.permit(:input, :file, :apiURL)
    end
end
