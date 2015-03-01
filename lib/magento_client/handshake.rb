class MagentoClient
  module Handshake
    def get_verifier_code
      jar = HTTP::CookieJar.new

      authorize_url = request_token.authorize_url
      response = HTTParty.get(authorize_url)
      jar.parse(response.headers['set-cookie'], authorize_url)
      
      doc = Nokogiri::HTML.fragment(response.body)
      form = extract_form(doc.css('form#loginForm'))
      form[:vars]['login[username]'] = @config.username
      form[:vars]['login[password]'] = @config.password


      response = HTTParty.post(form[:action],
        :body => form[:vars],
        :headers => { 'Cookie' => HTTP::Cookie.cookie_value(jar.cookies(form[:action])) }
      )
      jar.parse(response.headers['set-cookie'], form[:action])

      doc = Nokogiri::HTML.fragment(response.body)
      form = extract_form(doc.css('form#oauth_authorize_confirm'))
      raise "Didn't get a token value" unless form[:vars]['oauth_token']


      response = HTTParty.get(form[:action],
        :query => form[:vars],
        :headers => { 'Cookie' => HTTP::Cookie.cookie_value(jar.cookies(form[:action])) }
      )
      jar.parse(response.headers['set-cookie'], form[:action])
      verifier_code = extract_verifier_code(response.body)
      raise "Didn't get a verifier code" unless verifier_code

      verifier_code
    end


    private

    def extract_verifier_code(body)
      body.match(/Verifier code: (\w+)/) do
        return $1
      end
    end

    def extract_form(form)
      {
        :vars => form.css('input').each_with_object({}) do |e, obj|
            obj[e.attr('name')] = e.attr('value')
          end,
        
        :action => form.attr('action')
      }
    end

  end
end
