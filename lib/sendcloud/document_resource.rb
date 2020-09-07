module Sendcloud
  class DocumentResource < Base
    def get(link)
      self.class.get(link, basic_auth: auth).body
    end
  end
end
