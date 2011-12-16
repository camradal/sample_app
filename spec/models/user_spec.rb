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
    @attr = {
        :name => "Example User",
        :email => "user@example.com",
        :password => "foobar",
        :password_confirmation => "foobar"
    }
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

  describe "password validations" do

    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).should_not be_valid
    end

    it "should require a password match confirmation" do
      User.new(@attr.merge(:password => "", :password_confirmation => "invalid")).should_not be_valid
    end

    it "should reject short passwords" do
      short_pass = "a" * 5
      User.new(@attr.merge(:password => short_pass, :password_confirmation => short_pass)).should_not be_valid
    end

    it "should reject long passwords" do
      long_pass = "a" * 41
      User.new(@attr.merge(:password => long_pass, :password_confirmation => long_pass)).should_not be_valid
    end
  end

  describe "password encryption" do

    before (:each) do
      @user = User.create!(@attr)
    end

    it "should require encrypted password" do
      @user.should respond_to(:encrypted_password)
    end

    it "should not be blank" do
      @user.encrypted_password.should_not be_blank
    end

    describe "has_password? method" do

      it "should be true if passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end

      it "should be false if password do not match" do
        @user.has_password?("invalid").should be_false
      end
    end

    describe "authenticate method" do

      it "should not authenticate invalid email" do
        non_existent_user = User.authenticate(@attr[:email], "wrongpass")
        non_existent_user.should be_nil
      end

      it "should not authenticate invalid password" do
        invalid_pass_user = User.authenticate("foo@bar.com", @attr[:password])
        invalid_pass_user.should be_nil
      end

      it "should authenticate valid user" do
        valid_user = User.authenticate(@attr[:email], @attr[:password])
        valid_user.should == @user
      end
    end
  end
end
