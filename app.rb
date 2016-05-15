require 'sinatra/base'
require 'json'
require 'roo'
require 'rubyXL'


class MappingLearning < Sinatra::Base
  set :root, File.dirname(__FILE__)
  enable :sessions

  before do
    #define an uuid for saving file
    session[:id] ||= SecureRandom.uuid if session[:id].nil?
  end




  get '/' do

    @flash = {}
    p session[:id]

    xlsx_file = "tmp/#{session[:id]}.xlsx"

    if File.file?(xlsx_file)

      #Rescue to prevent any incorrect xlsx format
      begin
        @@question_answer = read_xlsx(xlsx_file)
        q_r_size = @@question_answer.size
        sized_randdom_number = rand(0..q_r_size-1)
        @question = @@question_answer.keys[sized_randdom_number]
      rescue
        @flash[:error] = 'This file is not available xlsx'
      end

    else
      @flash[:info] = 'Upload a xlsx file first'
    end

    erb :index
  end


  post '/answer', :provides => :json do

    question = params[:question]
    answer = params[:answer]
    @flash = {}

    #we get no answer if size is 0
    unless answer.size == 0
      if @@question_answer[question] == answer
        reponse = {correct_or_not: flash_class(:success), answer: "#{answer} is the correct answer"}
      else
        reponse = {correct_or_not: flash_class(:error), answer: "Sorry #{@@question_answer[question]} was the correct answer"}
      end

      if request.xhr?
        halt 200, reponse.to_json
      end
    end

  end


  post '/upload' do
    require 'roo'
    @flash = {}

    if params[:file]
      tempfile = params[:file][:tempfile]

      begin
        workbook = RubyXL::Parser.parse(tempfile)

        #change file name with session uuid
        workbook.write("tmp/#{session[:id]}.xlsx")
      rescue Zip::Error
        @flash[:error] = 'File have to be in xlsx'
        File.delete("tmp/#{session[:id]}.xlsx") if File.exist?("tmp/#{session[:id]}.xlsx")
        redirect '/'
      end

    end

    redirect '/'
  end


  def flash_class(level)
    case level
      when :success then "alert alert-success"
      when :error then "alert alert-danger"
      when :info then "alert alert-info"
    end
  end


  def read_xlsx(path)
    require 'roo'
    @flash = {}
    begin
      spreadsheet = Roo::Excelx.new(path)
    rescue Ole::Storage::FormatError
      raise 'File error'
    end
    @@question_answer = {}
    spreadsheet.each_with_pagename do |_, sheet|
      2.upto(sheet.last_row) do |line|
        row = sheet.row(line)
        @@question_answer[row[0]] = row[1].strip
      end
    end
    return @@question_answer
  end

end
