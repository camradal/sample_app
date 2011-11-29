# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe User do

  before (:each) do
    @attr = { :name => "Example User", :email => "user@example.com" }
  end

  it "should create a user" do
    User.create!(@attr)
  end

  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end

  it "should require an email" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end

  it "should reject names that are too long" do
    long_name = "a" * 51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end

  it "should accept valid emails" do
    addresses = %w[user@foo.com the_user@foo.bar.com first.last@foo.jp]
    addresses.each do |address|
      valid_user = User.new(@attr.merge(:email => address))
      valid_user.should be_valid
    end
  end

  it "should reject invalid emails" do
    addresses = %w[user,@foo.com the_user.bar.com first.last@foo.]
    addresses.each do |address|
      invalid_user = User.new(@attr.merge(:email => address))
      invalid_user.should_not be_valid
    end
  end

  it "should reject dupes" do
    User.create!(@attr)
    user_dupe = User.new(@attr)
    user_dupe.should_not be_valid
  end

  it "should ignore case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_dupe_email = User.new(@attr)
    user_dupe_email.should_not be_valid
  end

end
