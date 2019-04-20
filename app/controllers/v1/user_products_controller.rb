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

    def add
      if UserProduct.where(user_id: @user.id, product_id: params[:id]).present?
        respond_with_error('unprocessable_entity')
      else
        @user_product = UserProduct.create(user_id: @user.id, product_id: params[:id], purchase_date: Time.now)
        render json: { product: Product.find(params[:id]) }, status: :ok
      end
    end

    def destroy
      @user_product = UserProduct.where(product_id: params[:id])
      if @user_product.present?
        @user_product.destroy
        render json: { success: 'Successfully deleted' }, status: :ok
      else
        respond_with_error('not_found')
      end
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
          # after products are found from an image, perform async query job in the background
          IngredientWorker.perform_async(product_ids.map(&:to_s))
          render json: { products: Product.find(product_ids) }, status: :ok
        else
          respond_with_error('not_found')
        end
      else
        respond_with_error('not_found')
      end
    end

    def get_recommended_foods
      # get product ids of a user (foods added/scanned)
      product_ids = @user.user_products.map(&:product_id)
      recommended_foods = []
      # get recommended foods from the product_ids
      FoodRecommend.where(id: { :$in => product_ids }).each do |recommended_food|
        recommended_foods += Product.order_by(score: :desc).find(recommended_food.recommended_product_ids)
      end
      render json: { food_recommended: recommended_foods }, status: :ok
    end

    def get_recipes
      uri = URI("http://www.recipepuppy.com/api/?i=#{params[:ingredients]}&p=#{params[:page] ? params[:page] : '1'}")
      recipes = JSON.parse(Net::HTTP.get(uri))['results']
      recipes.each do |recipe|
        recipe['id'] = recipe['title']
      end
      render json: { recipes: recipes }, status: :ok
    end

    private

    # Param: parsed text of an image
    # Return: an array of product ids that match with the text
    def add_products_to_user(text)
      product_ids = []
      set = Set.new
      counter = {}
      text.split("\n").each do |line|
        # skip price (non-alphabet) texts
        next if line.count("a-zA-Z") == 0
        food_words = []
        line.strip.split.each do |w|
          # for accurate query, skip words consisting of 1 or 2 characters
          food_words << w if w.length > 2
        end
        food_text = food_words.join(' ')
        # add food text to the set to prevent duplicate items searched
        if set.include? food_text
          counter[food_text] += 1
        else
          counter[food_text] = 1
        end
        set.add(food_text)
      end

      counter.each do |k, v|
        # search long_name of product that matches with the parsed text
        product = Product.search(k, fields: [{long_name: :word_start}]).first
        if product.present?
          product_ids << product.id
          unless UserProduct.where(user_id: @user.id, product_id: product.id).present?
            UserProduct.create(user_id: @user.id, product_id: product.id, purchase_date: Time.now, count: v)
          end
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