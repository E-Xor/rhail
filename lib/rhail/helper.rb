require 'json'

module Rhail

  ##
  #
  # Helper for all http response related needs.
  #
  class Helper
    ##
    #
    # Exception for the case when Rhail::Helper.token_auth doesn't receive right parameters.
    #
    class FailedTokenAuth < Exception; end

    ##
    #
    # Renders html.
    # It concatenates files specified in +files+ parameter.
    # If +local_vars+ specified it also make Ruby string evaluation so var value will appera in html.
    # If +headers+ provided also adds them, good for caching headers.
    #
    # Example:
    #
    #   Rhail::Helper.render_html files: %w(head home foot), local_vars: {page: 'home'}
    #
    def self.render_html(files: ['index'], local_vars: nil, headers: {})

      res = Rack::Response.new

      html = ''
      if local_vars
        files.each {|fn| html +=  eval('%Q(' + File.read("public/html/#{fn}.html") + ')') }
      else
        files.each {|fn| html += File.read("public/html/#{fn}.html") }
      end

      res['Content-Type'] = 'text/html'
      headers.each do |k, v|
        res[k] = v
      end if headers
      res.write html

      res.finish

    end

    ##
    #
    # Renders json form hash in +response_structure+.
    # If +status+ provided overwrites 200.
    # If +headers+ provided adds them to response. Good for caching headers.
    #
    # Example:
    #
    #   Rhail::Helper.render_json(response_structure: some_hash)
    #
    def self.render_json(response_structure: {}, status: 200, headers: {})


      res = Rack::Response.new([], status, {})

      res['Content-Type'] = 'application/json'
      headers.each do |k, v|
        res[k] = v
      end if headers
      res.write response_structure.to_json

      res.finish

    end

    ##
    #
    # When JSON request is expected converts it to Hash.
    #
    # Example:
    #
    #   req = Rack::Request.new(env)
    #   params = Rhail::Helper.params_from_json_request(req)
    #
    def self.params_from_json_request(req)
      JSON.parse(req.body.read)
    end

    ##
    # Authenticates request based on token.
    # +valid_token+ source is up to developer, in generators it's just in a config file.
    # In real life you can use database or key-value storage and get it from there.
    # If token is not valid renders 401 with error in json.
    #
    # Example:
    #
    #   Rhail::Helper.token_auth(env['HTTP_AUTHORIZATION'], valid_token) do |t|
    #     Rhail::Helper.render_json(response_structure: some_hash)
    #   end
    #
    def self.token_auth(http_auth_header, valid_token)


      raise FailedTokenAuth unless http_auth_header
      type, token = http_auth_header.split(' ')

      raise FailedTokenAuth if type != 'Token'
      token_value = token.sub('token="', '').chop rescue raise(FailedTokenAuth)
      raise FailedTokenAuth if token_value != valid_token

      puts "Access granted"
      yield token_value

    rescue FailedTokenAuth, ::StandardError => e
      puts e.message
      render_json(response_structure: {status: '401', code: 'Unauthorized', detail: 'Access denied'}, status: 401)
    end

  end
end