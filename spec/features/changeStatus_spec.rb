require 'rails_helper'

describe "Change accountStatus" do
  # Common HTTP request headers, put in variable for ease of use - DRY!
  request_headers = {"Accept" => "application/json", "Content-Type" => "application/json"}

  before(:each) do
    @aUser = User.new
    @aUser.email = "allen@smartass.com"
    @aUser.password = "password"
    @aUser.uid = 123
    @aUser.planID = 345
    @aUser.accountStatus = "ACTIVE"
    @aUser.save
  end

  it "should be able to update accountStatus to ACTIVE" do
    message_to_hl_rails_server = '{"command" : "changeStatus", "uid" : "123", "planID" : "456", "accountStatus" : "ACTIVE"}'
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
    expect(response_from_hl_rails_server["message"]).to eq "accountStatus is ACTIVE"
  end

  it "should be able to update accountStatus to DISABLED" do
    message_to_hl_rails_server = '{"command" : "changeStatus", "uid" : "123", "planID" : "456", "accountStatus" : "DISABLED"}'
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
    expect(response_from_hl_rails_server["message"]).to eq "accountStatus is DISABLED"
  end

  it "should be able to update accountStatus to DELETED" do
    message_to_hl_rails_server = '{"command" : "changeStatus", "uid" : "123", "planID" : "456", "accountStatus" : "DELETED"}'
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
    expect(response_from_hl_rails_server["message"]).to eq "accountStatus is DELETED"
  end

  it "should not login a user with an invalid uid" do
    message_to_hl_rails_server = '{"command" : "changeStatus", "uid" : "007", "planID" : "456"}'
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
    message_to_hl_rails_server = '{"command" : "changeStatus", "uid" : "", "planID" : "456"}'
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
    message_to_hl_rails_server = '{"command" : "changeStatus", "planID" : "456"}'
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

  it "should not change a accountStatus if changeStatus is nil" do
    message_to_hl_rails_server = '{"command" : "changeStatus", "uid" : "123"}'
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
    expect(response_from_hl_rails_server["message"]).to eq "accountStatus not provided"
  end

  it "should not change a accountStatus if changeStatus is not valid" do
    message_to_hl_rails_server = '{"command" : "changeStatus", "uid" : "123", "accountStatus" : "WRONG!!!"}'
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
    expect(response_from_hl_rails_server["message"]).to eq "accountStatus not valid"
  end

  it "should not change a accountStatus if users changeStatus is DELETED" do
    @aUser.accountStatus = "DELETED"
    @aUser.save
    message_to_hl_rails_server = '{"command" : "changeStatus", "uid" : "123", "accountStatus" : "DELETED"}'
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
    expect(response_from_hl_rails_server["message"]).to eq "accountStatus is not restorable"
  end

end
