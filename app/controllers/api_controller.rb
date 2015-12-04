class ApiController < ActionController::Base

  def service
    #json = JSON.parse(params.to_s)
    json = JSON.parse('{"command" : "createUser", "email": "allan@smartass.com", "encrypted_password": "password", "uid": 123}')
    if json["command"] == "createUser"
      createUser(json)
    elsif json["command"] == "updatePlan"
      # TODO
    else
      render json: "ERROR", status: 400
    end
  end

  private
  def createUser json
    # TODO:actually create a user in the system/database
    newUser = User.new
    newUser.email = json["email"]
    newUser.password = json["encrypted_password"]
    newUser.uid = json["uid"]
    if newUser.save
      render json: "{\"success\":\"OK\", \"message\":\"User created\", \"uid\": \"#{newUser.uid}\"}", status: 200
    else
      render json: '{"success":"FAILURE", "message":"User NOT created"}', status: 400
    end
  end


end
