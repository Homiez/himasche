# -*- coding: utf-8 -*-
class SessionsController < ApplicationController

  def new
    #render :text => sentence

    session[:hima_day] = params[:hima_day]
    redirect_to '/auth/twitter'
  end


  def create
    auth = request.env["omniauth.auth"]
    user = User.where(:provider => auth['provider'], 
                      :uid => auth['uid']).first || User.create_with_omniauth(auth)
    session[:user_id] = user.id
    user.hima_day = Date.strptime(session[:hima_day], "%Y-%m-%d")
    user.save  

    Twitter.configure do |config|
      config.consumer_key = 'v9Xh4Y4eLaagneo7HuYuWQ'
      config.consumer_secret = 'r5LeaBV8UsQqTxiZwZzN71CgWBKhr0nnzErCjMXrI'
      config.oauth_token = '427855540-LNN1qZ7fPn0skAwPYEmcIDpgZDwrMFXCHX52mAMJ'
      config.oauth_token_secret = 'xuzxEGI33QqtpmAxlB7bxbB8uJsi2s0VCPFbzM4'
    end

    @client = Twitter::Client.new

    botPhrases = ["勉強会に行くのはいかがでしょう？","登山に行くとかどうでしょう？", "多分、人が急遽足りなくなって、合コンに誘われる気がしますヨ。", "一風堂はお好きですか？　夕飯は一風堂がいいです"].sort_by{|i| rand }


    sentence = ""  
    sentence.concat(user.name)
    sentence.concat("さん　")
    sentence.concat(user.hima_day.strftime("%Y月%m日%d"))
    sentence.concat("は、")
    sentence.concat(botPhrases[0])
    sentence.concat(Time.now.to_s)
    @client.update(sentence)
    #render :text => sentence
    redirect_to root_url, :notice => 'Signed in!'
  end

  def destroy
    User.all.where(:id =>  session[:user_id]).destroy
    reset_session

    redirect_to root_url, :notice => 'Signed out!'
  end

  def failure
    redirect_to root_url, :alert => "Authentication error: #{params[:message].humanize}"
  end

end
