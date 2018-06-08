module ApplicationHelper
  
  # def gravatar_for(user, options = { size: 80 })
  #   gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
  #   size = options[:size]
  #   gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
  #   image_tag(gravatar_url, alt: user.chefname, class: "img-circle")
  # end
  
  
   
  



def gravatar_for(user, options = { size: 80 }) 
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    # gravatar_url = "https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50?r=pg/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.chefname, class: 'gravatar')
  end
  
end

