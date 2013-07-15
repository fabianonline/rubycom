# -*- encoding : utf-8 -*-
class StripsController < ApplicationController
	def show
		@strip = Strip.find(params[:id])
	end
end
