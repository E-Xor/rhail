require 'rhail/helper'
require 'yaml'
require 'sequel'

use Rack::Static, :urls => ['/img'], :root => 'public' # http://www.rubydoc.info/github/rack/rack/Rack/Static

SETTINGS    = YAML.load_file(File.expand_path('../settings.yml',__FILE__))
TOKEN_VALUE = SETTINGS['token']
DB          = Sequel.sqlite('db/database.sqlite3')

class WebApi

  def self.call(env)
    req = Rack::Request.new(env)

    case 
    when req.get? && req.path_info == '/'

      h = {
        one: '584c5915f896067cb0927bd6',
        two: 0,
        three: 'f5ef49a3-2b82-46f5-aa8f-1180f7dbef98',
        four: true,
        five: '$2,343.28',
        six: 33,
        seven: 'blue',
        eight: 'dot'
      }
      Rhail::Helper.token_auth(env['HTTP_AUTHORIZATION'], TOKEN_VALUE) do |t|
        Rhail::Helper.render_json(response_structure: h)
      end

    when req.get? && req.path_info == '/example_one'
      Rhail::Helper.token_auth(env['HTTP_AUTHORIZATION'], TOKEN_VALUE) do |t|
        people_with_addresses = DB[:people].left_join(:addresses, id: :address_id).select(:name, :city, :state, :zipcode).all
        Rhail::Helper.render_json(response_structure: people_with_addresses)
      end

    when req.post? && req.path_info == '/example_two'
      Rhail::Helper.token_auth(env['HTTP_AUTHORIZATION'], TOKEN_VALUE) do |t|
        params = Rhail::Helper.params_from_json_request(req)

        address_id = DB[:addresses].insert(city: params['city'], state: params['state'], zipcode: params['zipcode'])
        DB[:people].insert(name: params['name'], address_id: address_id)

        people_with_addresses = DB[:people].left_join(:addresses, id: :address_id).select(:name, :city, :state, :zipcode).all
        Rhail::Helper.render_json(response_structure: people_with_addresses)
      end
    end

  rescue => e
    Rhail::Helper.render_json(response_structure: {status: '500', code: 'Internal Server Error', detail: e.message}, status: 500)
  end

end

run WebApi

# curl -i -H 'Authorization: Token token="afbadb4ff8485c0adcba486b4ca90cc4"' http://127.0.0.1:9292/
# curl -i -H 'Authorization: Token token="afbadb4ff8485c0adcba486b4ca90cc4"' http://127.0.0.1:9292/example_one
# curl -i -H 'Authorization: Token token="afbadb4ff8485c0adcba486b4ca90cc4"' -H "Content-Type: application/json" -X POST -d '{"city":"asd","state":"asd","zipcode":"123","name":"asd"}' http://127.0.0.1:9292/example_two
