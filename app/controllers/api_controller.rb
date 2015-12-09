class ApiController < ApplicationController

  def service
    json = JSON.parse(request.body.read)
    if json["command"] == "createAccount"
      createAccount(json)
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
  def createAccount json
    if json["uid"]
      newAccount = User.new
      newAccount.email = json["email"]
      newAccount.password = json["encrypted_password"]
      newAccount.uid = json["uid"]
      if newAccount.save
        render json: "{\"success\":\"OK\", \"message\":\"Account created\", \"uid\": \"#{newAccount.uid}\"}", status: 200
      else
        render json: '{"success":"FAILURE", "message":"Account NOT created"}', status: 400
      end
    else
      render json: '{"success":"FAILURE", "message":"No UID. Account not created"}', status: 400
    end
  end

  def updatePlan json
    uid = json["uid"]
    planID = json["planID"]
    if uid.nil?
      render json: '{"success":"FAILURE", "message":"UID not provided"}', status: 400
    elsif uid == ""
        render json: '{"success":"FAILURE", "message":"UID not valid"}', status: 400
    else
      aUser = User.where("uid=" + uid).first
      if aUser.nil?
        render json: '{"success":"FAILURE", "message":"UID not valid"}', status: 400
      elsif planID.nil?
        render json: '{"success":"FAILURE", "message":"planID not valid"}', status: 400
      else
        aUser.planID = planID
        render json: '{"success":"OK", "message":"planID changed"}', status: 200
      end
    end
  end

  def changeStatus json
    uid = json["uid"]
    accountStatus = json["accountStatus"]
    if uid.nil?
      render json: '{"success":"FAILURE", "message":"UID not provided"}', status: 400
    elsif uid == ""
        render json: '{"success":"FAILURE", "message":"UID not valid"}', status: 400
    else
      aUser = User.where("uid=" + uid).first
      if aUser.nil?
        render json: '{"success":"FAILURE", "message":"UID not valid"}', status: 400
      elsif accountStatus.nil?
        render json: '{"success":"FAILURE", "message":"accountStatus not provided"}', status: 400
      elsif aUser.accountStatus == "DELETED"
        render json: '{"success":"FAILURE", "message":"accountStatus is not restorable"}', status: 400
      elsif accountStatus != "ACTIVE" && accountStatus != "DISABLED" && accountStatus != "DELETED"
        render json: '{"success":"FAILURE", "message":"accountStatus not valid"}', status: 400
      else
        aUser.accountStatus = accountStatus
        if accountStatus == "ACTIVE"
          render json: '{"success":"OK", "message":"accountStatus is ACTIVE"}', status: 200
        elsif accountStatus == "DISABLED"
          render json: '{"success":"OK", "message":"accountStatus is DISABLED"}', status: 200
        elsif accountStatus == "DELETED"
          render json: '{"success":"OK", "message":"accountStatus is DELETED"}', status: 200
        end
      end
    end
  end

  def loginUser json
    uid = json["uid"]
    if uid.nil?
      render json: '{"success":"FAILURE", "message":"UID not provided"}', status: 400
    elsif uid == ""
        render json: '{"success":"FAILURE", "message":"UID not valid"}', status: 400
    else
      aUser = User.where("uid=" + uid).first
      if aUser.nil?
        render json: '{"success":"FAILURE", "message":"UID not valid"}', status: 400
      elsif sign_in(aUser)
          render json: "{\"success\":\"OK\", \"message\":\"User logged in\", \"uid\": \"#{aUser.uid}\", \"loginURL\":\"http://localhost:3000/users/#{aUser.id}\"}", status: 200
      else
          render json: '{"success":"FAILURE", "message":"User not logged in"}', status: 400
      end
    end
  end
end
