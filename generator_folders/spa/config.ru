require 'rhail/helper'
require 'yaml'
require 'sequel'

use Rack::Static, :urls => ['/img', '/css', '/js', '/html'], :root => 'public'
DB = Sequel.sqlite('db/database.sqlite3')
use Rack::Session::Pool

class Spa

  def self.call(env)
    req = Rack::Request.new(env)

    case
    when req.get? && req.path_info == '/'

      Rhail::Helper.render_html(files: ['index'])

    when req.get? && req.path_info == '/api/example_one'

      people_with_addresses = DB[:people].left_join(:addresses, id: :address_id).select(:name, :city, :state, :zipcode).all
      req.session['csrf.token'] = SecureRandom.urlsafe_base64(32)
      Rhail::Helper.render_json(response_structure: people_with_addresses, headers: {'csrf_token' => env['rack.session']['csrf.token']})

    when req.post? && req.path_info == '/api/example_two'

      params = Rhail::Helper.params_from_json_request(req)

      if env['HTTP_CSRF_TOKEN'] == req.session['csrf.token']

        address_id = DB[:addresses].insert(city: params['city'], state: params['state'], zipcode: params['zipcode'])
        DB[:people].insert(name: params['name'], address_id: address_id)

        Rhail::Helper.render_json(response_structure: {result: 'OK'})

      else
        Rhail::Helper.render_json(response_structure: {error: 'CSRF mismatch!'}, status: 400)
      end
    end

  rescue => e
    puts e.message
    puts e.backtrace
    Rhail::Helper.render_json(response_structure: {status: '500', error: 'Internal Server Error'}, status: 500)
  end

end

run Spa
