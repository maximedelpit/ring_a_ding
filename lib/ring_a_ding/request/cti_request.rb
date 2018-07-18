module RingADing
  class CtiRequest < Request
    BASE_API_URL = 'https://ssl.keyyo.com/'

    def path
      super + ".html"
    end
  end
end

