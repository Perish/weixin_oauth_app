namespace :download_qrcode do
	desc %Q|下载微信二维码|
	task :run => :environment do
		Qrcode.all.each do |qrcode|
			# puts qrcode.image_url
			puts qrcode.id
			qrcode.load_image
		end
	end

	task :remove => :environment do
		Qrcode.all.each do |qrcode|
			qrcode.image.destroy
		end
	end

	task :zip => :environment do
		Qrcode.zip_qrcode([7,6])
	end
end