module Citygram::Routes
  module Helpers
    LINK_TEMPLATE = ERB.new(<<-ERB.dedent)
      <a href="<%= url.gsub(/\.\z/, '') %>" target="_blank"><%= url %></a>
    ERB

    def hyperlink(str)
      # extract an array of urls
      urls = URI.extract(str).select do |url|
        # handle edge cases like `more:`, which is extracted by URI.extract
        URI(url) rescue false
      end

      # create 'a' tags from urls
      links = urls.map do |url|
        LINK_TEMPLATE.result(binding)
      end

      # swap in the html tag
      links.zip(urls).each do |link, url|
        str = str.gsub(url, link)
      end

      str
    end

    def build_url(base, path, params = {})
      url = URI(base)
      url.path = path if path
      url.query = Rack::Utils.build_query(params) if params.any?
      url.to_s
    end

    module_function :hyperlink, :build_url
  end
end
