require 'rubygems'
require 'sinatra'
require 'erb'

before do
  @api_site = "http://api.pluspanda.com"
  if !params[:apikey].nil?
    # redirect to new api method.
    # TODO: log referrer so we know who's still using the old api.
    redirect @api_site + "/testimonials/widget.js?" + request.query_string
  end
  
  @links = ['home', 'pricing', 'faq', 'contact']
  @active ||= request.path_info.split('/')[1]
  @admin_action_url = @api_site + "/admin"
  @admin_homepage_url = @api_site + "/admin"
end

# redirect the add link: 
  # http://pluspanda.com/testimonials/add/cI7eHawz
  # http://localhost:3000/testimonials/new?apikey=577ed4ada1f60e44
get '/testimonials/add/:apikey' do
  redirect @api_site + "/testimonials/new?apikey=" + params[:apikey]
end

['/', '/home'].each do |path|
  get path do
    @meta   = 'Embedable customer testimonials and reviews for your business website.'
    @title  = 'Easily Collect, Manage, and Display Customer Testimonials On Your Website'
    @active = 'home'
    @content = erb :index
    @widget_url = "http://localhost:3000/testimonials/widget.js?apikey=c1b0262bae41a328"
    @embed_code = "fill this in later"
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