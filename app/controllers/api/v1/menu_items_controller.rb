class Api::V1::MenuItemsController < ApplicationController
    def index
      @menu_items = MenuItem.where(available: true)
      render json: @menu_items
    end
end