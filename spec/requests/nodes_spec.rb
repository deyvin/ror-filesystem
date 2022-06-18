require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/nodes", type: :request do
  # This should return the minimal set of attributes required to create a valid
  # Node. As you add validations to Node, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {
      name: "MyString",
    }
  }

  let(:invalid_attributes) {
    # skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the headers
  # in order to pass any filters (e.g. authentication) defined in
  # NodesController, or in your router and rack
  # middleware. Be sure to keep this updated too.
  let(:valid_headers) {
    {}
  }

  # describe "GET /index" do
  #   it "renders a successful response" do
  #     Node.create! valid_attributes
  #     get nodes_url, headers: valid_headers, as: :json
  #     expect(response).to be_successful
  #   end
  # end

  # describe "GET /show" do
  #   it "renders a successful response" do
  #     node = Node.create! valid_attributes
  #     get node_url(node), as: :json
  #     expect(response).to be_successful
  #   end
  # end

  describe "POST /create" do
      it "creates a new Node" do
        post nodes_url, params: valid_attributes, headers: valid_headers, as: :json
        
        expect(response).to have_http_status(:created)
      end

      it "cannot create two nodes same name in root" do
        post nodes_url, params: { name: 'new node' }, headers: valid_headers, as: :json
        post nodes_url, params: { name: 'new node' }, headers: valid_headers, as: :json
        
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "creates a new node inside parent" do
        post nodes_url, params: { name: 'root node' }, headers: valid_headers, as: :json
        parsed_root_body = JSON.parse(response.body)

        post nodes_url, params: { name: 'child node', parent_id: parsed_root_body['id']}, headers: valid_headers, as: :json
        parsed_child_body = JSON.parse(response.body)        
        
        expect(parsed_child_body["parent_id"]).to eq(parsed_root_body['id'])
        expect(response).to have_http_status(:created)
      end    
  end

  # describe "PATCH /update" do
  #   context "with valid parameters" do
  #     let(:new_attributes) {
  #       skip("Add a hash of attributes valid for your model")
  #     }

  #     it "updates the requested node" do
  #       node = Node.create! valid_attributes
  #       patch node_url(node),
  #             params: { node: new_attributes }, headers: valid_headers, as: :json
  #       node.reload
  #       skip("Add assertions for updated state")
  #     end

  #     it "renders a JSON response with the node" do
  #       node = Node.create! valid_attributes
  #       patch node_url(node),
  #             params: { node: new_attributes }, headers: valid_headers, as: :json
  #       expect(response).to have_http_status(:ok)
  #       expect(response.content_type).to match(a_string_including("application/json"))
  #     end
  #   end

  #   context "with invalid parameters" do
  #     it "renders a JSON response with errors for the node" do
  #       node = Node.create! valid_attributes
  #       patch node_url(node),
  #             params: { node: invalid_attributes }, headers: valid_headers, as: :json
  #       expect(response).to have_http_status(:unprocessable_entity)
  #       expect(response.content_type).to match(a_string_including("application/json"))
  #     end
  #   end
  # end

  # describe "DELETE /destroy" do
  #   it "destroys the requested node" do
  #     node = Node.create! valid_attributes
  #     expect {
  #       delete node_url(node), headers: valid_headers, as: :json
  #     }.to change(Node, :count).by(-1)
  #   end
  # end
end
