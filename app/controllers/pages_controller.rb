class PagesController < ApplicationController
  def home
    @title = 'Home'
  end

  def contract
    @title = 'Contract'
  end

  def about
    @title = 'About'
  end

end
