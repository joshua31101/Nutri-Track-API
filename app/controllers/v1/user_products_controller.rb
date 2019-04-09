module V1
  class UserProductsController < ApplicationController
    before_action :find_user

    def index
      @products = Product.find(@user.user_products.map(&:product_id))
      render json: { products: @products }, status: :ok
    end

    def create
    end

    def show
    end

    def destroy
    end

    def upload
      require 'net/http'

      uri = URI('http://api.ocr.space/parse/image')
      req = Net::HTTP::Post.new(uri)
      form_data = [
        ['file', params[:file].tempfile],
        ['language', 'eng'],
        ['apikey', ENV['OCR_API_KEY']]
      ]
      req.set_form(form_data, 'multipart/form-data')
      res = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(req)
      end

      case res
      when Net::HTTPSuccess
        product_ids = add_products_to_user(JSON.parse(res.body)['ParsedResults'][0]['ParsedText'])
        if product_ids.present?
          IngredientWorker.perform_async(product_ids)
          render json: { products: Product.find(product_ids) }, status: :ok
        else
          respond_with_error('not_found')
        end
      else
        respond_with_error('not_found')
      end
    end

    private

    def add_products_to_user(text)
      product_ids = []
      set = Set.new
      counter = {}
      text.split("\n").each do |line|
        # skip price (non-alphabet) texts
        next if line.count("a-zA-Z") == 0
        food_words = []
        line.strip.split.each do |w|
          food_words << w if w.length > 1
        end
        food_text = food_words.join(' ')
        if set.include? food_text
          counter[food_text] += 1
        else
          counter[food_text] = 1
        end
        set.add(food_text)
      end

      counter.each do |k, v|
        product = Product.search(k, fields: [{long_name: :word_start}]).first
        if product.present?
          product_ids << product.id
          UserProduct.create(user_id: @user.id, product_id: product.id, purchase_date: Time.now, count: v)
        end
      end
      return product_ids
    end

    def find_user
      @user = User.find(params[:user_id])
      rescue Mongoid::Errors::DocumentNotFound
        respond_with_error('not_found')
    end
  end
end