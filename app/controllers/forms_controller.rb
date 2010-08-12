class FormsController < ApplicationController

  skip_before_filter :verify_authenticity_token, :only => [:submit]

  def index
    @forms = GoogleForm.all
  end
  
  def show
    slug = params[:id]
    if @google_form = GoogleForm.find_by_slug(slug)
      response  = @google_form.fetch_form_page!
      form_html = response.body
      if doc = clean_up_html(form_html)
        render :text => doc.to_html
      else
        render :text => "error loading form"
      end
    else
      redirect_to '/'
    end
  end

  def thank_you
    @google_form = GoogleForm.find(params[:id])
  end
  
  def submit
    if @google_form = GoogleForm.find(params[:id])
      params.delete(:id)
      params.delete(:action)
      params.delete(:controller)
      google_form_action = params.delete(:google_form)
      response = @google_form.submit(google_form_action, params)
      result_html = response.body
      if result_html =~ %r{<title>Thanks!<\/title>}
        render :text => @google_form.thank_you_message
      elsif result_html =~ /Moved Temporarily/
        render :text => "Ooh, this form has been moved or disabled. How odd."
      else
        if doc = clean_up_html(result_html)
          render :text => doc.to_html
        else
          render :text => result_html
        end
      end
    end
  end

  private
  def clean_up_html(form_html)
    doc = Nokogiri::HTML(form_html)
    doc.xpath("//*[@style]").remove_attr('style')
    doc.xpath("//*[@class='ss-legal']").each { |n| n.unlink }
    doc.xpath("//link").each { |n| n.unlink }
    doc.xpath("//style").each { |n| n.unlink }
    
    google_form = doc.xpath("//form").first
    return false unless google_form
    google_form_action = google_form["action"]
    google_form["action"] = submit_form_url(@google_form, :google_form => google_form_action)

    css_node = doc.create_element('link')
    css_node["href"] = "/stylesheets/reset.css"
    css_node["rel"] = "stylesheet"
    css_node["type"] = "text/css"
    doc.xpath("//head").first.add_child(css_node)
    
    css_node = doc.create_element('link')
    css_node["href"] = "/stylesheets/google_forms.css?#{Time.new.to_i}"
    css_node["rel"] = "stylesheet"
    css_node["type"] = "text/css"
    doc.xpath("//head").first.add_child(css_node)
    
    footer = doc.create_element('div')
    footer["id"] = "footer"
    doc.xpath("//body").first.add_child(footer)
    
    # analytics = doc.create_element('div')
    # analytics.inner_html = render_to_string :partial => 'layouts/google_analytics'
    # doc.xpath("//body").first.add_child(analytics)
    doc
  end
end
