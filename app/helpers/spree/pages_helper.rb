module Spree::PagesHelper
  def render_snippet(slug)
    page = Spree::Page.find_by_slug(slug)
    raw page.body if page
  end

  def render_static_page(slug)
    page = Spree::Page.by_slug(slug).first
    raw(parse(page.body)) if page
  end

  def parse(text)
    text.gsub!(/{{(.*)}}/) {|match| call_helper($1)}
    text.gsub!(/<%=(.*)%>/) {|match| call_eval($1)}
    text.html_safe
  end

  def link_to_page(*params)
    slug, text = params
    page = Spree::Page.find_by_slug(slug)
    text ||= page.title
    link_to(text.html_safe, page.slug)
  end

  private

  def call_eval(eval_string)
    eval eval_string
  end

  def call_helper(call_string)
    match = /(\w+)(.*)/.match(call_string)
    helper_name = match[1]
    params = match[2]
    params = params.scan(/(['"])(.*?)\1/).collect{|x| x[1]}
    
    if self.respond_to?(helper_name)
      self.send(helper_name, *params)
    else
      call_string
    end
  end
end