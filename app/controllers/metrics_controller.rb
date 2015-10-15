class MetricsController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

	def show_metrics
		@data = get_data
		respond_to do |format|
			format.html
			format.json { render json: @data }
		end

	end


	def get_data
		hsh ={}
		hsh["x_axis"] = {}
		hsh["x_axis"]["type"] = "datetime"
		hsh["series"] = set_data_series
		hsh.to_json
	end


	def set_data_series
		spreadsheet = Roo::CSV.new("#{Rails.root}/install.csv",csv_options: {encoding: "UTF-16LE"})
		series_arr = []
		hsh = {}
		hsh["name"] = "Current Device Installs"
		data_arr = []
		(2..spreadsheet.last_row).map do |i|
			data_arr.push([spreadsheet.row(i)[0],spreadsheet.row(i)[2].to_i])
		end
		hsh["data"] = data_arr
		series_arr.push(hsh)

		hsh = {}
		hsh["name"] = "Daily Device Installs"
		data_arr = []
		(2..spreadsheet.last_row).map do |i|
			data_arr.push([spreadsheet.row(i)[0],spreadsheet.row(i)[3].to_i])
		end
		hsh["data"] = data_arr

		series_arr.push(hsh)

		hsh = {}
		hsh["name"] = "Daily Device Uninstalls"
		data_arr = []
		(2..spreadsheet.last_row).map do |i|
			data_arr.push([spreadsheet.row(i)[0],spreadsheet.row(i)[4].to_i])
		end
		hsh["data"] = data_arr

		series_arr.push(hsh)


	end

end
