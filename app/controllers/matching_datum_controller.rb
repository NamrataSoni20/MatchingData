require 'spreadsheet'

class MatchingDatumController < ApplicationController

    def index

    end 

    def new
        @matching_datum = MatchingDatum.new
    end 

    def create
        @matching_datum = MatchingDatum.create(matching_datum_params)
        if @matching_datum.errors.present?
            render 'new'
        else
            redirect_to matching_datum_index_path
        end
        
    end 

    private

    def matching_datum_params
        params.require(:matching_datum).permit(:email, :file)
    end 

end 