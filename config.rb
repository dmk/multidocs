# frozen_string_literal: true

data.apis.each_key do |id|
  proxy id, 'swagger-ui.html', layout: 'api'
end

configure :build do
  activate :asset_hash
  activate :gzip
  activate :minify_css
  activate :minify_javascript
end
