require 'rails_helper'

RSpec.describe Inquiry, type: :model do
  include_context "db_cleanup"

  it "default iquiry created with random title and question" do
    inquiry=FactoryGirl.build(:inquiry)
    expect(inquiry.customer_id).to_not be_nil
    expect(inquiry.save).to be true
  end

  it "inquiry with User" do
    user=FactoryGirl.create(:user)
    inquiry=FactoryGirl.build(:inquiry, customer_id: user.id)
    expect(inquiry.customer_id).to eq(user.id)
    expect(inquiry.title).to_not be_nil
    expect(inquiry.question).to_not be_nil
    expect(inquiry.save).to be true      
  end

  it "inquiry with not User, Title and Question" do
    inquiry=FactoryGirl.build(:inquiry, customer_id: nil, title: nil, question: nil)
    expect(inquiry.validate).to be false
    expect(inquiry.errors.messages).to include(:customer_id=>["can't be blank"])
    expect(inquiry.errors.messages).to include(:title=>["can't be blank"])
    expect(inquiry.errors.messages).to include(:question=>["can't be blank"])   
  end
end
