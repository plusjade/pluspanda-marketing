require 'rubygems'
require 'sinatra'
require 'erb'

before do
  @api_site = "http://api.pluspanda.com"
  @api_site_versioned = "http://api.pluspanda.com/v1"
  
  if !params[:apikey].nil?
    # redirect to new api method.
    # TODO: log referrer so we know who's still using the old api.
    content_type "text/javascript"
    redirect @api_site_versioned + "/testimonials/widget.js?" + request.query_string
  end
  
  @links = ['home', 'pricing', 'faq', 'contact', 'activity']
  @active ||= request.path_info.split('/')[1]
  @admin_action_url = @api_site + "/admin"
  @admin_homepage_url = @api_site + "/admin"
end

# redirect the add link: 
  # http://pluspanda.com/testimonials/add/cI7eHawz
  # http://localhost:3000/testimonials/new?apikey=577ed4ada1f60e44
get '/testimonials/add/:apikey' do
  redirect @api_site_versioned + "/testimonials/new?apikey=" + params[:apikey]
end

['/', '/home'].each do |path|
  get path do
    @meta       = 'Embedable customer testimonials and reviews for your business website.'
    @title      = 'Easily Collect, Manage, and Display Customer Testimonials On Your Website'
    @active     = 'home'
    @widget_url = @api_site_versioned + "/testimonials/widget.js?apikey=nbE6zpH"
    @embed_code = "fill this in later"
    @content    = erb :index
    erb :template
  end
end

get '/pricing' do
  @meta   = 'Plans and pricing for testimonial and review layouts and templates for your website'
  @title  = 'Plans and Pricing'
  @content = erb :pricing
  erb :template
end


get '/faq' do
  @meta   = 'Pluspanda website testimonial template builder frequently asked questions'
  @title  = 'Frequenty Asked Questions '
  @content = erb :faq
  erb :template
end


get '/contact' do
  @meta   = 'Pluspanda website testimonials builder contact information'
  @title  = 'Contact me'
  @content = erb :contact
  erb :template
end


get '/activity' do
  @meta   = ''
  @title  = 'Development Activity'
  
  require 'net/http'
  require 'uri'
  require 'json'
  
  url = URI.parse('http://github.com/api/v2/json/commits/list/plusjade/pluspanda/master')
     res = Net::HTTP.start(url.host, url.port) {|http|
       http.get('/api/v2/json/commits/list/plusjade/pluspanda/master')
     }
  @github = JSON.parse(res.body)

  @content = erb :activity
  erb :template
end

get '/test' do
  @meta   = ''
  @title  = 'Test APi =)'

  require 'net/http'
  require 'uri'
  require 'json'
  
  local_url = 'http://localhost:3000/testimonials.json?apikey=79ccf4bb93bd623b'
  local_get = '/testimonials.json?apikey=79ccf4bb93bd623b'
  production_url = @api_site_versioned + '/testimonials.json?apikey=nbE6zpH' 
  production_get = '/testimonials.json?apikey=nbE6zpH'
  
  
  url = URI.parse(production_url)
     res = Net::HTTP.start(url.host, url.port) {|http|
       http.get(production_get)
     }

  data          = JSON.parse(res.body)
  @testimonials = data["testimonials"]
  @data         = data["update_data"]
  @content      = erb :test
  erb :template
end

  
get '/terms_of_service' do
  @meta   = ''
  @title  = 'Terms of Service'  
  @content = erb :terms_of_service
  erb :template
end


get '/privacy_policy' do
  @meta   = ''
  @title  = 'Privacy Policy'
  @content = erb :privacy_policy
  erb :template
end   

not_found do
  @meta   = '404 Not Found'
  @title  = '404 Not Found!'
  @content = erb :error_404
  erb :template
end