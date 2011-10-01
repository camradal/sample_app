require 'spec_helper'

describe PagesController do
  render_views

  describe "GET 'home'" do
    it "should be successful" do
      get 'home'
      response.should be_success
    end

    it "should have the right title" do
      get 'home'
      response.should have_selector("title", :content => "Ruby on Rails Tutorial Sample App | Home")
    end
  end

  describe "GET 'contract'" do
    it "should be successful" do
      get 'contract'
      response.should be_success
    end

    it "should have right title" do
      get 'contract'
      response.should have_selector("title", :content => "Ruby on Rails Tutorial Sample App | Contract")
    end
  end

  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      response.should be_success
    end

    it "should have right title" do
      get 'about'
      response.should have_selector("title", :content => "Ruby on Rails Tutorial Sample App | About")
    end
  end

end
