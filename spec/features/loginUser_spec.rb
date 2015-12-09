require 'rails_helper'

describe "Logging in" do
  # Common HTTP request headers, put in variable for ease of use - DRY!
  request_headers = {"Accept" => "application/json", "Content-Type" => "application/json"}

  before(:each) do
    @aUser = User.new
    @aUser.email = "allen@smartass.com"
    @aUser.password = "password"
    @aUser.uid = 123
    @aUser.save
  end

  it "should be able to login a user with a valid uid" do
    message_to_hl_rails_server = '{"command" : "loginUser", "uid" : "123"}'
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
    expect(response_from_hl_rails_server["message"]).to eq "User logged in"
    expect(response_from_hl_rails_server["loginURL"]).to eq "http://localhost:3000/users/#{@aUser.id}"
    expect(response_from_hl_rails_server["uid"]).to eq "123"
  end

  it "should not login a user with a invalid uid" do
    message_to_hl_rails_server = '{"command" : "loginUser", "uid" : "007"}'
    # send message to hl server
    page.driver.post("/api/service", message_to_hl_rails_server, request_headers)
    # Check returned status code from the HL rails server
    expect(page.status_code).to eq 400
    expect(page.response_headers["Content-Type"].include?('json')).to eq true
    # parse the contents of the message we got from the server
    response_from_hl_rails_server = JSON.parse(body)
    # Check contents of message
    expect(response_from_hl_rails_server["success"]).to eq "FAILURE"
    expect(response_from_hl_rails_server["message"]).to eq "UID not valid"
  end

  it "should not login a user without a valid uid" do
    message_to_hl_rails_server = '{"command" : "loginUser", "uid" : ""}'
    # send message to hl server
    page.driver.post("/api/service", message_to_hl_rails_server, request_headers)
    # Check returned status code from the HL rails server
    expect(page.status_code).to eq 400
    expect(page.response_headers["Content-Type"].include?('json')).to eq true
    # parse the contents of the message we got from the server
    response_from_hl_rails_server = JSON.parse(body)
    # Check contents of message
    expect(response_from_hl_rails_server["success"]).to eq "FAILURE"
    expect(response_from_hl_rails_server["message"]).to eq "UID not valid"
  end

  it "should not login a user without a uid" do
    message_to_hl_rails_server = '{"command" : "loginUser"}'
    page.driver.post("/api/service", message_to_hl_rails_server, request_headers)
    # Check returned status code from the HL rails server
    expect(page.status_code).to eq 400
    expect(page.response_headers["Content-Type"].include?('json')).to eq true
    # parse the contents of the message we got from the server
    response_from_hl_rails_server = JSON.parse(body)
    # Check contents of message
    expect(response_from_hl_rails_server["success"]).to eq "FAILURE"
    expect(response_from_hl_rails_server["message"]).to eq "UID not provided"
  end
end
