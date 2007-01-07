class PageRenderer
  
  def initialize(controller)
    @controller = controller
  end
  
  def make_link(name, options = {}, css_class = '')
    href = @controller.url_for options
    %{<a class="#{css_class}" href="#{href}">#{name}</a>}
  end
  
end

