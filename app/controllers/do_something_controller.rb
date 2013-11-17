class DoSomethingController < ApplicationController
  require 'edan'
  def main
    # generate random integer for random offset value in call.
    # 31,114 is the number of records in the set with images

        # instantiate edan object.
    eq = EDANQuery.new("JasonsTestApp")

    begin
      searchResults = eq.request("q=#{params[:search][:search_field]}&wt=json&fq=online_media_type:Images")
      sResults = JSON.parse(searchResults.body)
      cap = sResults["response"]["numFound"]
      random = rand(cap).to_i
    rescue
      random = 0
    end

    random.inspect # for debugging

    # make a call for single row with random offset value; but make sure it has an image also.
      begin
        res = eq.request("rows=1&q=#{params[:search][:search_field]}&start=#{random}&wt=json&fq=online_media_type:Images")
      rescue
        res = eq.request("rows=1&wt=json&fq=online_media_type:Images")
      end
      # parse the results.
      res.code.inspect  # for debugging
      if res.code == "200"
        @fields = JSON.parse(res.body)
      end

    # do something to the results.
    # return the post-processed data to view.
    render
  end
end