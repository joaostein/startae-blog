require 'rack/contrib/try_static'
require 'rack/contrib/not_found'
require 'rack/contrib/static_cache'
require 'rack/cache'

if ENV['RACK_ENV'] == 'production'
  use Rack::Auth::Basic, 'Login required' do |username, password|
    [username, password] == [ENV['USERNAME'], ENV['PASSWORD']]
  end
end

if ENV['CANONICAL_HOST']
  require 'rack-canonical-host'
  use Rack::CanonicalHost, ENV['CANONICAL_HOST']
end

Rack::Mime::MIME_TYPES['.webapp'] = 'application/x-web-app-manifest+json'

use Rack::Head
use Rack::Deflater

use Rack::Cache,
  :metastore => 'heap:/',
  :entitystore => 'heap:/',
  :allow_reload => false,
  :allow_revalidate => false,
  :cache_key => proc { |req| req.path_info.gsub('/', '-') }

use Rack::StaticCache,
  :root => 'build',
  :urls => %w(/images /stylesheets /javascripts'),
  :versioning => false

use Rack::TryStatic,
  :root => 'build',
  :urls => %w[/],
  :try => %w(index.html /index.html)

page_not_found = Rack::NotFound.new(File.join('build', '404.html'))

must_revalidate = proc do |env|
  page = page_not_found.call(env)
  page[1]['Cache-Control'] = 'must-revalidate'
end
run must_revalidate