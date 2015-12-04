require 'rails_helper'

describe "create user json" do

  it "should create a user from an API, returing a uid and success message" do
    message_to_hl_rails_server = '{"command" : "createUser", "email" : "allan@smartass.com", "encrypted_password" : "password", "uid" : 123}'
    request_headers = {"Accept" => "application/json", "Content-Type" => "application/json"}
    # send message to hl server
    page.driver.post("/api/service", message_to_hl_rails_server, request_headers)
    # Check returned status code from the HL rails server
    expect(page.status_code).to eq 200
    # Check that we got json back
    expect(page.response_headers["Content-Type"].include?('json')).to eq true
    # parse the contents of the message we got from the server
    response_from_hl_rails_server = JSON.parse(body)
    # Check contents of message
    expect(response_from_hl_rails_server["success"]).to eq "OK"
    # TODO
    puts response_from_hl_rails_server
    # TODO Check that user is in the database with the correct database
    uid = response_from_hl_rails_server["uid"]
    users = User.where("uid=" + uid )
    expect(users.first.email).to eq "allan@smartass.com"
    # TODO check all the other data on user
  end
end
