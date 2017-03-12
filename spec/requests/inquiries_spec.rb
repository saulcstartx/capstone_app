require 'rails_helper'

RSpec.describe "Inquiries", type: :request do
  include_context "db_cleanup_each"
  let(:account) { apply_originator(signup(FactoryGirl.attributes_for(:user)), Inquiry) }

  context "quick API check" do
    let!(:user) { login account }

    it_should_behave_like "resource index", :inquiry
    it_should_behave_like "show resource", :inquiry
    it_should_behave_like "create resource", :inquiry
    it_should_behave_like "modifiable resource", :inquiry
  end

  shared_examples "cannot create" do |status=:unauthorized|
    it "create fails with #{status}" do
      jpost inquiries_path, inquiry_props
      expect(response).to have_http_status(status)
      expect(parsed_body).to include("errors")
    end
  end
  shared_examples "cannot update" do |status|
    it "update fails with #{status}" do
      jput inquiry_path(inquiry_id), FactoryGirl.attributes_for(:inquiry)
      expect(response).to have_http_status(status)
      expect(parsed_body).to include("errors")
    end
  end
  shared_examples "cannot delete" do |status|
    it "delete fails with #{status}" do
      jdelete inquiry_path(inquiry_id), inquiry_props
      expect(response).to have_http_status(status)
      expect(parsed_body).to include("errors")
    end
  end
  shared_examples "cannot index" do |status=:unauthorized|
    it "index fails with #{status}" do
      jget inquiries_path
      expect(response).to have_http_status(status)
      expect(parsed_body).to include("errors")
    end
  end
  shared_examples "cannot show" do |status=:unauthorized|
    it "show fails with #{status}" do
      jget inquiry_path(inquiry_id)
      expect(response).to have_http_status(status)
      expect(parsed_body).to include("errors")
    end
  end
  shared_examples "can create" do
    it "is created" do
      jpost inquiries_path, inquiry_props
      #pp parsed_body
      expect(response).to have_http_status(:created)
      payload=parsed_body
      expect(payload).to include("id")
      expect(payload).to include("title"=>inquiry_props[:title])
      expect(payload).to include("question"=>inquiry_props[:question])
      expect(payload).to include("user_roles")
      expect(payload["user_roles"]).to include(Role::ORGANIZER)
      expect(Role.where(:user_id=>user["id"],:role_name=>Role::ORGANIZER)).to exist
    end
  end
  shared_examples "can update" do
    it "can update" do
      jput inquiry_path(inquiry_id), inquiry_props
      expect(response).to have_http_status(:no_content)
    end
  end
  shared_examples "can delete" do
    it "can delete" do
      jdelete inquiry_path(inquiry_id)
      expect(response).to have_http_status(:no_content)
    end
  end
  shared_examples "all fields present" do |user_roles|
    it "list has all fields with user_roles #{user_roles}" do
      jget inquiries_path
      expect(response).to have_http_status(:ok)
      #pp parsed_body
      payload=parsed_body
      expect(payload.size).to_not eq(0)
      payload.each do |r|
        expect(r).to include("id")
        expect(r).to include("title")
        expect(r).to include("question")
        if user_roles.empty?
          expect(r).to_not include("user_roles")
        else
          expect(r).to include("user_roles")
          expect(r["user_roles"].to_a).to include(*user_roles)
        end
      end
    end
    it "get has all fields with user_roles #{user_roles}" do
      jget inquiry_path(inquiry_id)
      expect(response).to have_http_status(:ok)
      #pp parsed_body
      payload=parsed_body
      expect(payload).to include("id"=>inquiry.id)
      expect(payload).to include("title"=>inquiry.title)
      expect(payload).to include("question"=>inquiry.question)
      if user_roles.empty?
        expect(payload).to_not include("user_roles")
      else
        expect(payload).to include("user_roles")
        expect(payload["user_roles"].to_a).to include(*user_roles)
      end
    end
  end
  shared_examples "empty fields" do |user_roles|
    it "list has all fields with user_roles #{user_roles}" do
      jget inquiries_path
      expect(response).to have_http_status(:ok)
      payload=parsed_body
      expect(payload.size).to eq(0)
    end
  end

  describe "Inquiry authorization" do
    let(:alt_account) { signup FactoryGirl.attributes_for(:user) }
    let(:admin_account) { apply_admin(signup FactoryGirl.attributes_for(:user)) }
    let(:inquiry_props) { FactoryGirl.attributes_for(:inquiry) }
    let(:inquiry_resources) { 3.times.map { create_resource inquiries_path, :inquiry } }
    let(:inquiry_id)  { inquiry_resources[0]["id"] }
    let(:inquiry)     { Inquiry.find(inquiry_id) }

    context "caller is unauthenticated" do
      before(:each) { login account; inquiry_resources; logout }
      it_should_behave_like "cannot index"
      it_should_behave_like "cannot show"
      it_should_behave_like "cannot create"
      it_should_behave_like "cannot update", :unauthorized
      it_should_behave_like "cannot delete", :unauthorized
    end
    context "caller is authenticated organizer" do
      let!(:user)   { login account }
      before(:each) { inquiry_resources }
      it_should_behave_like "can create"
      it_should_behave_like "can update"
      it_should_behave_like "can delete"
      it_should_behave_like "all fields present", [Role::ORGANIZER]
    end
    context "caller is authenticated non-organizer" do
      before(:each) { login account; inquiry_resources; login alt_account }
      it_should_behave_like "cannot show", :forbidden
      it_should_behave_like "cannot update", :forbidden
      it_should_behave_like "cannot delete", :forbidden
      it_should_behave_like "cannot index", :forbidden
    end
    context "caller is admin" do
      before(:each) { login account; inquiry_resources; login admin_account }
      it_should_behave_like "cannot show", :forbidden
      it_should_behave_like "cannot update", :forbidden
      it_should_behave_like "cannot delete", :forbidden
      it_should_behave_like "cannot index", :forbidden
    end

  end
end