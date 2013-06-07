require 'rack/contrib/try_static'
require 'rack/contrib/not_found'
require 'rack/contrib/static_cache'
require 'rack/cache'

page_not_found = Rack::NotFound.new(File.join('build', '404.html'))

must_revalidate = proc do |env|
  page = page_not_found.call(env)
  page[1]['Cache-Control'] = 'must-revalidate'
end
run must_revalidate