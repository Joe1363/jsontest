require 'rails_helper'

describe "create user json" do
  # Common HTTP request headers, put in variable for ease of use - DRY!
  request_headers = {"Accept" => "application/json", "Content-Type" => "application/json"}

  it "should create a user from an API, returing a uid and success message" do
    message_to_hl_rails_server = '{"command" : "createUser", "email" : "allan@smartass.com", "encrypted_password" : "password", "uid" : 123}'
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
    expect(response_from_hl_rails_server["message"]).to eq "User created"
    expect(response_from_hl_rails_server["uid"]).to eq "123"
    #  Check that user is in the database with the correct database
    uid = response_from_hl_rails_server["uid"]
    users = User.where("uid=" + uid )
    expect(users.first.email).to eq "allan@smartass.com"
    expect(users.first.encrypted_password).to_not eq ""
    expect(users.first.uid).to eq 123

  end

  it "should CRASH & BURN no command" do
    message_to_hl_rails_server = '{"email" : "allan@smartass.com", "encrypted_password" : "password"}'
    # send message to hl server
    page.driver.post("/api/service", message_to_hl_rails_server, request_headers)
    # Check returned status code from the HL rails server
    expect(page.status_code).to eq 400
    # Check that we got json back
    expect(page.response_headers["Content-Type"].include?('json')).to eq true
    # parse the contents of the message we got from the server
    response_from_hl_rails_server = JSON.parse(body)
    # Check contents of message
    expect(response_from_hl_rails_server["success"]).to eq "FAILURE"
    expect(response_from_hl_rails_server["message"]).to eq "Missing or No Command"
  end

  it "should CRASH & BURN wrong command" do
    message_to_hl_rails_server = '{"command" : "OhNoUDidnt", "email" : "allan@smartass.com", "encrypted_password" : "password"}'
    # send message to hl server
    page.driver.post("/api/service", message_to_hl_rails_server, request_headers)
    # Check returned status code from the HL rails server
    expect(page.status_code).to eq 400
    # Check that we got json back
    expect(page.response_headers["Content-Type"].include?('json')).to eq true
    # parse the contents of the message we got from the server
    response_from_hl_rails_server = JSON.parse(body)
    # Check contents of message
    expect(response_from_hl_rails_server["success"]).to eq "FAILURE"
    expect(response_from_hl_rails_server["message"]).to eq "Missing or No Command"
  end

  # TODO: finish this test
  it "should CRASH & BURN no uid" do
    message_to_hl_rails_server = '{"command" : "createUser", "email" : "allan@smartass.com", "encrypted_password" : "password"}'
    # send message to hl server
    page.driver.post("/api/service", message_to_hl_rails_server, request_headers)
    # Check returned status code from the HL rails server
    expect(page.status_code).to eq 400
    # Check that we got json back
    expect(page.response_headers["Content-Type"].include?('json')).to eq true
    # parse the contents of the message we got from the server
    response_from_hl_rails_server = JSON.parse(body)
    # Check contents of message
    expect(response_from_hl_rails_server["success"]).to eq "FAILURE"
    expect(response_from_hl_rails_server["message"]).to eq "UID missing"
  end
end
