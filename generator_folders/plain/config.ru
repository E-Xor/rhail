require 'rhail/helper'
require 'sequel'
require 'securerandom'

use Rack::Static, :urls => ['/img', '/css'], :root => 'public' # http://www.rubydoc.info/github/rack/rack/Rack/Static
use Rack::Session::Pool

DB = Sequel.sqlite('db/database.sqlite3')

class RhailPlain
  def self.call(env)

    req = Rack::Request.new(env)

    case 
    when req.get? && req.path_info == '/'

      Rhail::Helper.render_html files: %w(head home foot), local_vars: {page: 'home'}

    when req.get? && req.path_info == '/example_one'

      Rhail::Helper.render_html files: %w(head example_one foot), local_vars: {page: 'example_one'}

    when req.get? && req.path_info == '/example_two'

      Rhail::Helper.render_html files: %w(head example_two foot), local_vars: {page: 'example_two'}

    when req.post? && req.path_info == '/example_two' # post

      Rhail::Helper.render_html files: %w(head example_two foot), local_vars: {page: 'example_two', results: req.params}

    when req.get? && req.path_info == '/example_three'

      req.session['csrf.token'] = SecureRandom.urlsafe_base64(32)

      people_with_addresses = DB[:people].left_join(:addresses, id: :address_id).select(:name, :city, :state, :zipcode).all

      Rhail::Helper.render_html files: %w(head example_three foot), local_vars: {page: 'example_three', results: people_with_addresses, csrf_token: env['rack.session']['csrf.token']}

    when req.post? && req.path_info == '/example_three' # post

      params = req.params

      if params['csrf_token'] == req.session['csrf.token']

        address_id = DB[:addresses].insert(city: params['city'], state: params['state'], zipcode: params['zipcode'])
        DB[:people].insert(name: params['name'], address_id: address_id)

      else
        puts "CSRF check failed."
      end

      [302, {'Location' => '/example_three', 'Content-Type' => 'text/html'}, ['302 found']]
    end

  end
end

run RhailPlain
