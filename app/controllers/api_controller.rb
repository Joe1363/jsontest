class ApiController < ApplicationController

  def service
    json = JSON.parse(request.body.read)
    if json["command"] == "createUser"
      createUser(json)
    elsif json["command"] == "updatePlan"
      updatePlan(json)
    elsif json["command"] == "changeStatus"
      changeStatus(json)
    elsif json["command"] == "loginUser"
      loginUser(json)
    else
      render json: '{"success":"FAILURE", "message":"Missing or Incorrect Command"}', status: 400
    end
  end

  private
  def createUser json
    if json["uid"]
      newUser = User.new
      newUser.email = json["email"]
      newUser.password = json["encrypted_password"]
      newUser.uid = json["uid"]
      if newUser.save
        render json: "{\"success\":\"OK\", \"message\":\"User created\", \"uid\": \"#{newUser.uid}\"}", status: 200
      else
        render json: '{"success":"FAILURE", "message":"User NOT created"}', status: 400
      end
    else
      render json: '{"success":"FAILURE", "message":"No UID. User not created"}', status: 400
    end
  end

  def updatePlan
    #TODO
  end

  def changeStatus
    #TODO
  end

  def loginUser json
    uid = json["uid"]
    if uid.nil?
      render json: '{"success":"FAILURE", "message":"User ID not provided"}', status: 400
    elsif uid == ""
        render json: '{"success":"FAILURE", "message":"User ID not valid"}', status: 400
    else
      aUser = User.where("uid=" + uid).first
      if aUser.nil?
        render json: '{"success":"FAILURE", "message":"User ID not valid"}', status: 400
      elsif sign_in(aUser)
          render json: "{\"success\":\"OK\", \"message\":\"User logged in\", \"uid\": \"#{aUser.uid}\", \"loginURL\":\"http://localhost:3000/users/#{aUser.id}\"}", status: 200
      else
          render json: '{"success":"FAILURE", "message":"User not logged in"}', status: 400
      end
    end
  end
end
